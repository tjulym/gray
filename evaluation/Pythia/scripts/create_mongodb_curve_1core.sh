#!/bin/bash
# Run by: numactl -m 0 taskset -c 11 bash create_mongodb_curve_1core.sh 
# This script will call ./processing/process_bubble.py

CurrentDir=`pwd`
MONGODB_DIR="$CurrentDir/multi_app_with_qos/apps/mongodb"
MONGODB_BINARY_DIR="/media/xu943/disk2/mongodb-linux-x86_64-3.4.9"
YCSB_DIR="/media/xu943/disk2/ycsb-0.12.0"

YCSB_CORE="10"
BUBBLE_CORE="2"
REPORTER_CORE="1"

# Generates mongodb sensitive curve by running the mongodb(#1)+YCSB(#7) and bubble(#2) side by side

EXPERIMENT_NAME="mongodb_curve"
BINARY_DIR="bin"
PID_FILE="${EXPERIMENT_NAME}.pid"
OUTPUT_NAME="data/${EXPERIMENT_NAME}.reporter.perf_counters"

# Launch the mongodb in the background

## Prepare 
rm data/*
mkdir "$MONGODB_DIR/tmp"; rm -rf $MONGODB_DIR/tmp/*; rm -f $MONGODB_DIR/tmp/*;

## Start MongoDB server
cd "$CurrentDir"
# cmd: 
"${BINARY_DIR}/time" 2> "${OUTPUT_NAME}" | numactl -m 0 taskset -c "${REPORTER_CORE}" perf stat -I 1000 -e cycles,instructions --log-fd=3 -x ' ' "$MONGODB_BINARY_DIR/bin/mongod" --dbpath "$MONGODB_DIR/tmp" --pidfilepath "$MONGODB_DIR/tmp/app.pid" --quiet --port 28017 3>>"${OUTPUT_NAME}" 2> /dev/null 1> /dev/null &
MONGODB_PID=$!
echo $MONGODB_PID > "$MONGODB_DIR/tmp/app.pid"
# pid number in "$MONGODB_DIR/tmp/app.pid"

echo "Sleep 5 seconds for init"  
sleep 5 

## Start YCSB benchmark
cd "$CurrentDir"
rm output*.txt

bin/NewTime 2> data/Now.txt

echo "Now loading mongodb with YCSB data"
numactl -m 0 taskset -c "${YCSB_CORE}" ${YCSB_DIR}/bin/ycsb load mongodb-async -s -P "${YCSB_DIR}/workloads/workloadb" -p mongodb.url=mongodb://127.0.0.1:28017 -p status.interval=1 -p recordcount=100000 >> data/outputLoad.txt 2>> data/outputLoad.txt

echo "Now running mongodb with YCSB driver"
numactl -m 0 taskset -c "${YCSB_CORE}" ${YCSB_DIR}/bin/ycsb run mongodb-async -s -P "${YCSB_DIR}/workloads/workloadb" -p mongodb.url=mongodb://127.0.0.1:28017 -p status.interval=1 -p operationcount=15000000 >> data/outputRun.txt 2>> data/outputRun.txt &

YCSB_PID=$!
echo YCSB_PID=$YCSB_PID

echo "Sleep 35 seconds to wait the YCSB and mongodb stable"  
sleep 35 

# Start the bubble
# The time binary is run first to generate an absolute timestamp at the beginning
# The perf util output will contain relative offsets that will be added to the absolute
# initial timestamp and the post-processing script will perform registration between
# the reporter timestamps and the bubble timestamps
BUBBLE_SIZE_FILE="data/${EXPERIMENT_NAME}.bubble.size"
BUBBLE_PERF_COUNTERS="data/${EXPERIMENT_NAME}.bubble.perf_counters"

cd "$CurrentDir"
"${BINARY_DIR}/time" 2> "${BUBBLE_PERF_COUNTERS}" && 3>> "${BUBBLE_PERF_COUNTERS}" numactl -m 0 taskset -c "${BUBBLE_CORE}" perf stat --log-fd=3 -e instructions,cycles -I 600 "${BINARY_DIR}"/bubble 1.25 30000 1 |& tee "${BUBBLE_SIZE_FILE}"
if [ $? -ne 0 ]; then
	echo "Error: Failed to run bubble"
	exit 2
fi

# Terminate the YCSB
echo "Stop YCSB"
kill -9 $YCSB_PID
sleep 5
pkill -f "ycsb-0.12.0"
sleep 5

## Stop Mongodb server
echo "Stop Mongodb"
kill -9 $MONGODB_PID
sleep 5
pkill -f "mongodb-linux-x86_64-3.4.9"
sleep 5

# Run the post-processing script on the output
cd "$CurrentDir"
./processing/process_bubble.py "data/${EXPERIMENT_NAME}" "${BUBBLE_SIZE_FILE}" "${OUTPUT_NAME}" 0.2
if [ $? -ne 0 ]; then
	echo "Error: Failed to process the bubble"
	exit 3
fi

# Create a measure of the bubble-size on the bubble IPC
./processing/process_bubble.py "data/${EXPERIMENT_NAME}.bubble" "${BUBBLE_SIZE_FILE}" "${BUBBLE_PERF_COUNTERS}" 0.2
if [ $? -ne 0 ]; then
    echo "Error: Failed to process the bubble for the bubble process"
    exit 4
fi

exit

############################### For the use of debugging #################################
# Start Mongodb
rm /home/Pythia/pythia/multi_app_with_qos/apps/mongodb/tmp/*
rm -rf /home/Pythia/pythia/multi_app_with_qos/apps/mongodb/tmp/*
"/media/xu943/disk2/mongodb-linux-x86_64-3.4.9/bin/mongod" --dbpath "/home/Pythia/pythia/multi_app_with_qos/apps/mongodb/tmp" --pidfilepath "/home/Pythia/pythia/multi_app_with_qos/apps/mongodb/tmp/app.pid" --quiet --port 28017 3>>"data/mongodb_curve.reporter.perf_counters" &

/media/xu943/disk2/ycsb-0.12.0/bin/ycsb load mongodb-async -s -P "/media/xu943/disk2/ycsb-0.12.0/workloads/workloadb" -p mongodb.url=mongodb://127.0.0.1:28017 -p status.interval=1 -p recordcount=100000

/media/xu943/disk2/ycsb-0.12.0/bin/ycsb run mongodb-async -s -P "/media/xu943/disk2/ycsb-0.12.0/workloads/workloadb" -p mongodb.url=mongodb://127.0.0.1:28017 -p status.interval=1 -p operationcount=15000000 >>tmp.txt 2>>tmp.txt &

pkill -f "mongod"
pkill -f "ycsb-0.12.0"
pkill -f "bubble"








