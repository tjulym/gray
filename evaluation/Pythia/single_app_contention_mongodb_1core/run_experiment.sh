#!/bin/bash

# Need Python version with SciKit Learn installed
PYTHON="/usr/bin/python"

#
# INPUT: suite bmark rep cores
#

#
# OUTPUT: time mean_ipc estimated_bubble_mean median_ipc estimated_bubble_median
#

#
# NOTE: The taskset calls must be updated to reflect the appropriate processor topology
#
YCSB_CORE=7
BUBBLE_CORE=2
REPORTER_CORE=1

function run_parsec() {
	BMARK=$1
	CORES=$2
	numactl -m 0 taskset -c $BUBBLE_CORE parsecmgmt -a run -i native -n "${CORES}" -p "${BMARK}" > "${EXPERIMENT_LOG}"
}

function run_spec() {
	BMARK=$1
	numactl -m 0 taskset -c $BUBBLE_CORE runcpu --config=/home/Pythia/cpu2017/config/Ran.cfg --action=run --size=ref "${BMARK}" > "${EXPERIMENT_LOG}"
}

if [ $# -ne 4 ]; then
	echo "Error: Invalid number of arguments"
	echo "run_experiment.sh suite bmark rep cores"
	exit 1
fi

SUITE=$1
shift
BMARK=$1
shift
REP=$1
shift
CORES=$1
shift

EXPERIMENT_NAME="${SUITE}.${BMARK}.${REP}"
PID_FILE="logs/${EXPERIMENT_NAME}.pid"
OUTPUT_NAME="data/${EXPERIMENT_NAME}.reporter.perf_counters"
EXPERIMENT_LOG="logs/${EXPERIMENT_NAME}.log"

# Launch the mongodb+YCSB in the background
CurrentDir=`pwd`
MONGODB_DIR="$CurrentDir/../multi_app_with_qos/apps/mongodb"
MONGODB_BINARY_DIR="/media/xu943/disk2/mongodb-linux-x86_64-3.4.9"
YCSB_DIR="/media/xu943/disk2/ycsb-0.12.0"

rm -rf $MONGODB_DIR/tmp/*; rm -f $MONGODB_DIR/tmp/*;

## Start MongoDB server
# cmd: 
../bin/NewTime 2> data/Now.txt

"../bin/time" 2> "${OUTPUT_NAME}" | numactl -m 0 taskset -c "${REPORTER_CORE}" perf stat -I 1000 -D 60000 -e cycles,instructions --append --log-fd=3 -x ' ' "$MONGODB_BINARY_DIR/bin/mongod" --dbpath "$MONGODB_DIR/tmp" --pidfilepath "$MONGODB_DIR/tmp/app.pid" --quiet --port 28017 3>>"${OUTPUT_NAME}" 2> /dev/null 1> /dev/null &
MONGODB_PID=$!
echo $MONGODB_PID > "$MONGODB_DIR/tmp/app.pid"
# pid number in "$MONGODB_DIR/tmp/app.pid"

#echo "Sleep 5 seconds for init"  
sleep 5 

## Start YCSB benchmark
OUTPUT_YCSBLOAD_NAME="data/${EXPERIMENT_NAME}.outputLoad.txt"
OUTPUT_YCSBRUN_NAME="data/${EXPERIMENT_NAME}.outputRun.txt"
#echo "Now loading mongodb with YCSB data"
numactl -m 0 taskset -c "${YCSB_CORE}" ${YCSB_DIR}/bin/ycsb load mongodb-async -s -P "${YCSB_DIR}/workloads/workloadb" -p mongodb.url=mongodb://127.0.0.1:28017 -p status.interval=1 -p recordcount=100000 >> "${OUTPUT_YCSBLOAD_NAME}" 2>> "${OUTPUT_YCSBLOAD_NAME}"

#echo "Now running mongodb with YCSB driver"
numactl -m 0 taskset -c "${YCSB_CORE}" ${YCSB_DIR}/bin/ycsb run mongodb-async -s -P "${YCSB_DIR}/workloads/workloadb" -p mongodb.url=mongodb://127.0.0.1:28017 -p status.interval=1 -p operationcount=15000000 >> "${OUTPUT_YCSBRUN_NAME}" 2>> "${OUTPUT_YCSBRUN_NAME}" &

YCSB_PID=$!
#echo YCSB_PID=$YCSB_PID
StopYCSBLog="data/${EXPERIMENT_NAME}.YCSB_PID"

# Run the batch application
if [ "x${SUITE}" == "xparsec" ]; then
	run_parsec "${BMARK}" "${CORES}" &
	if [ $? -ne 0 ]; then
		echo "Error: Failed to run benchmark"
        kill `cat "${PID_FILE}"`
        rm "${PID_FILE}"
       	exit 2
	fi
elif [ "x${SUITE}" == "xspec_int" -o "x${SUITE}" == "xspec_fp" ]; then
	run_spec "${BMARK}" &
	if [ $? -ne 0 ]; then
		echo "Error: Failed to run benchmark"
        kill `cat "${PID_FILE}"`
        rm "${PID_FILE}"
		exit 2
	fi
fi

# Wait for 100 seconds
sleep 100

# Terminate the YCSB
kill -9 $YCSB_PID
pkill -f "ycsb-0.12.0"

## Stop Mongodb server
kill -9 $MONGODB_PID
pkill -f "mongodb-linux-x86_64-3.4.9"
sleep 10
echo "YCSB+Mongodb stopped, see as follows" > $StopYCSBLog
echo `ps -aux | grep "mongod"` >> $StopYCSBLog
echo "----------------------" >> $StopYCSBLog
echo `ps -aux | grep "ycsb"` >> $StopYCSBLog

pkill -f "run_base_refspeed"
pkill -f "cpu2017"
pkill -f "runcpu"
pkill -f "parsec-3.0"
sleep 5
rm -rf ~/cpu2017/benchspec/CPU/*/run
rm -rf ~/PARSEC-3.0/parsec-3.0/pkgs/apps/*/run

# Remove the first measurement of perf counter (in-place edit)
sed -i -e '2,3d' "${OUTPUT_NAME}"
# Perform processing out the output data
../processing/process_perf.py "data/${EXPERIMENT_NAME}.reporter" "${OUTPUT_NAME}" >> "${EXPERIMENT_LOG}"
if [ $? -ne 0 ]; then
	echo "Error: Failed to process timeseries"
	exit 3
fi

# Compute both the mean and median of the timeseries IPC
# values to determine the different values have
MEAN_IPC=`../processing/average_timeseries.py "data/${EXPERIMENT_NAME}.reporter.ipc" "mean" 2>> "${EXPERIMENT_LOG}"`
if [ $? -ne 0 ]; then
	echo "Error: Failed to average timeseries"
	exit 4
fi

MEDIAN_IPC=`../processing/average_timeseries.py "data/${EXPERIMENT_NAME}.reporter.ipc" "median" 2>> "${EXPERIMENT_LOG}"`
if [ $? -ne 0 ]; then
    echo "Error: Failed to average timeseries"
    exit 5
fi

P95_IPC=`../processing/average_timeseries.py "data/${EXPERIMENT_NAME}.reporter.ipc" "95th" 2>> "${EXPERIMENT_LOG}"`
if [ $? -ne 0 ]; then
    echo "Error: Failed to average timeseries"
    exit 6
fi

P99_IPC=`../processing/average_timeseries.py "data/${EXPERIMENT_NAME}.reporter.ipc" "99th" 2>> "${EXPERIMENT_LOG}"`
if [ $? -ne 0 ]; then
    echo "Error: Failed to average timeseries"
    exit 7
fi

REPORTER_CURVE="../data/mongodb_curve.bubble_size.ipc.medians"
BUBBLE_MEAN=`"${PYTHON}" ../processing/estimate_bubble.py ${REPORTER_CURVE} ${MEAN_IPC} 2>> "${EXPERIMENT_LOG}"`
if [ $? -ne 0 ]; then
	echo "Error: Failed to estimate bubble size"
	exit 8
fi
BUBBLE_MEDIAN=`"${PYTHON}" ../processing/estimate_bubble.py ${REPORTER_CURVE} ${MEDIAN_IPC} 2>> "${EXPERIMENT_LOG}"`
if [ $? -ne 0 ]; then
	echo "Error: Failed to estimate bubble size"
	exit 9
fi
BUBBLE_P95=`"${PYTHON}" ../processing/estimate_bubble.py ${REPORTER_CURVE} ${P95_IPC} 2>> "${EXPERIMENT_LOG}"`
if [ $? -ne 0 ]; then
	echo "Error: Failed to estimate bubble size"
	exit 10
fi
BUBBLE_P99=`"${PYTHON}" ../processing/estimate_bubble.py ${REPORTER_CURVE} ${P99_IPC} 2>> "${EXPERIMENT_LOG}"`
if [ $? -ne 0 ]; then
	echo "Error: Failed to estimate bubble size"
	exit 11
fi


# Output final result over stdout
echo "0 ${MEAN_IPC} ${BUBBLE_MEAN} ${MEDIAN_IPC} ${BUBBLE_MEDIAN} ${P95_IPC} ${BUBBLE_P95} ${P99_IPC} ${BUBBLE_P99}"

exit 0
