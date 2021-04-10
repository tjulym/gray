#!/bin/bash
# This script will call ./processing/process_bubble.py

CurrentDir=`pwd`
REDIS_DIR="$CurrentDir/multi_app_with_qos/apps/redis"
REDIS_BINARY_DIR="/media/xu943/disk2/redis-stable"
YCSB_DIR="/media/xu943/disk2/ycsb-0.12.0"

YCSB_CORE=7
BUBBLE_CORE=2
REPORTER_CORE=1

# Generates redis sensitive curve by running the redis(#0)+YCSB(#7) and bubble(#2) side by side

EXPERIMENT_NAME="redis_curve"
BINARY_DIR="bin"
PID_FILE="${EXPERIMENT_NAME}.pid"
OUTPUT_NAME="data/${EXPERIMENT_NAME}.reporter.perf_counters"

# Launch the redis in the background

## Prepare 
rm data/*
cd "$CurrentDir/multi_app_with_qos"
mkdir "$REDIS_DIR/tmp"; rm "$REDIS_DIR/tmp/*";

## Start Redis server
cd "$CurrentDir"
# cmd: ${REDIS_DIR}/src/redis-server "${CONFIG_FILE}" --dir "${DATA_DIR}" --pidfile "${DATA_DIR}/app.pid" 2>&1 > /dev/null &
"${BINARY_DIR}/time" 2> "${OUTPUT_NAME}" | numactl -m 0 taskset -c "${REPORTER_CORE}" perf stat -I 1000 -e cycles,instructions --log-fd=3 -x ' ' "$REDIS_BINARY_DIR/src/redis-server" "$REDIS_DIR/redis.config" --dir "$REDIS_DIR/tmp" --pidfile "$REDIS_DIR/tmp/app.pid" 3>>"${OUTPUT_NAME}" 2> /dev/null 1> /dev/null &
REDIS_PID=$!
echo $REDIS_PID > "$REDIS_DIR/tmp/app.pid"
# pid number in "$REDIS_DIR/tmp/app.pid"

echo "Sleep 5 seconds for init"  
sleep 5 

## Start YCSB benchmark
cd "$CurrentDir"
rm output*.txt

bin/NewTime 2> data/Now.txt

echo "Now loading redis with YCSB data"
numactl -m 0 taskset -c "${YCSB_CORE}" ${YCSB_DIR}/bin/ycsb load redis -s -P "${YCSB_DIR}/workloads/workloadb" -p status.interval=1 -p recordcount=100000 -p "redis.host=127.0.0.1" -p "redis.port=6379" >> data/outputLoad.txt 2>> data/outputLoad.txt

echo "Now running redis with YCSB driver"
numactl -m 0 taskset -c "${YCSB_CORE}" ${YCSB_DIR}/bin/ycsb run redis -s -P "${YCSB_DIR}/workloads/workloadb" -p status.interval=1 -p operationcount=15000000 -p "redis.host=127.0.0.1" -p "redis.port=6379" >> data/outputRun.txt 2>> data/outputRun.txt &

YCSB_PID=$!
echo YCSB_PID=$YCSB_PID

echo "Sleep 15 seconds to wait the YCSB and redis stable"  
sleep 15 

# Start the bubble
# The time binary is run first to generate an absolute timestamp at the beginning
# The perf util output will contain relative offsets that will be added to the absolute
# initial timestamp and the post-processing script will perform registration between
# the reporter timestamps and the bubble timestamps
BUBBLE_SIZE_FILE="data/${EXPERIMENT_NAME}.bubble.size"
BUBBLE_PERF_COUNTERS="data/${EXPERIMENT_NAME}.bubble.perf_counters"

cd "$CurrentDir"
"${BINARY_DIR}/time" 2> "${BUBBLE_PERF_COUNTERS}" && 3>> "${BUBBLE_PERF_COUNTERS}" numactl -m 0 taskset -c "${BUBBLE_CORE}" perf stat --log-fd=3 -e instructions,cycles -I 600 "${BINARY_DIR}"/bubble 1.25 12000 1 |& tee "${BUBBLE_SIZE_FILE}"
if [ $? -ne 0 ]; then
	echo "Error: Failed to run bubble"
	exit 2
fi

# Terminate the YCSB
echo "Stop YCSB"
kill $YCSB_PID
sleep 5
pkill -f "ycsb-0.12.0"
sleep 5

## Stop Redis server
echo "Stop redis"
kill $REDIS_PID
sleep 5
pkill -f "redis-server"
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
