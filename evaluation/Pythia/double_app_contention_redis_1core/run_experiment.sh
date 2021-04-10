#!/bin/bash

# Need Python version with SciKit Learn installed
PYTHON="/usr/bin/python"

#
# INPUT: suite bmark cores suite2 bmark2 cores2 rep
#

#
# OUTPUT: time mean_ipc estimated_bubble_mean median_ipc estimated_bubble_median
#

#
# NOTE: The taskset calls must be updated to reflect the appropriate processor topology
#
YCSB_CORE=7
BUBBLE_CORE1=2
BUBBLE_CORE2=4
REPORTER_CORE=1

function run_parsec() {
	BMARK=$1
	CORES=$2
	numactl -m 0 taskset -c $CORES parsecmgmt -a run -i native -n "${CORES}" -p "${BMARK}" 
}

function run_spec() {
	BMARK=$1
	CORES=$2
	numactl -m 0 taskset -c $CORES runcpu --config=/home/Pythia/cpu2017/config/Ran.cfg --action=run --size=ref "${BMARK}"
}

if [ $# -ne 7 ]; then
	echo "Error: Invalid number of arguments"
	echo "run_experiment.sh suite bmark rep cores"
	exit 1
fi

SUITE=$1
shift
BMARK=$1
shift
CORES=$1
shift
SUITE2=$1
shift
BMARK2=$1
shift
CORES2=$1
shift
REP=$1
shift

EXPERIMENT_NAME="${SUITE}.${BMARK}.${CORES}.${SUITE2}.${BMARK2}.${CORES2}.${REP}"
OUTPUT_NAME="data/${EXPERIMENT_NAME}.reporter.perf_counters"
EXPERIMENT_LOG="logs/${EXPERIMENT_NAME}.log"
EXPERIMENT_LOG2="logs/${EXPERIMENT_NAME}.log2"

rm $OUTPUT_NAME
rm $EXPERIMENT_LOG
rm $EXPERIMENT_LOG2
# Launch the redis+YCSB in the background
CurrentDir=`pwd`
REDIS_DIR="$CurrentDir/../multi_app_with_qos/apps/redis"
REDIS_BINARY_DIR="/media/xu943/disk2/redis-stable"
YCSB_DIR="/media/xu943/disk2/ycsb-0.12.0"

mkdir "$REDIS_DIR/tmp"; rm "$REDIS_DIR/tmp/*";

## Start Redis server
# cmd: ${REDIS_DIR}/src/redis-server "${CONFIG_FILE}" --dir "${DATA_DIR}" --pidfile "${DATA_DIR}/app.pid" 2>&1 > /dev/null &
../bin/NewTime 2> data/Now.txt
 
"../bin/time" 2> "${OUTPUT_NAME}" | numactl -m 0 taskset -c "${REPORTER_CORE}" perf stat -I 1000 -D 40000 -e cycles,instructions --append --log-fd=3 -x ' ' "$REDIS_BINARY_DIR/src/redis-server" "$REDIS_DIR/redis.config" --dir "$REDIS_DIR/tmp" --pidfile "$REDIS_DIR/tmp/app.pid" 3>>"${OUTPUT_NAME}" 2> /dev/null 1> /dev/null &
REDIS_PID=$!
echo $REDIS_PID > "$REDIS_DIR/tmp/app.pid"
# pid number in "$REDIS_DIR/tmp/app.pid"

#echo "Sleep 5 seconds for init"  
sleep 5 

## Start YCSB benchmark
OUTPUT_YCSBLOAD_NAME="data/${EXPERIMENT_NAME}.outputLoad.txt"
OUTPUT_YCSBRUN_NAME="data/${EXPERIMENT_NAME}.outputRun.txt"
rm $OUTPUT_YCSBLOAD_NAME
rm $OUTPUT_YCSBRUN_NAME
#echo "Now loading redis with YCSB data"
numactl -m 0 taskset -c "${YCSB_CORE}" ${YCSB_DIR}/bin/ycsb load redis -s -P "${YCSB_DIR}/workloads/workloadb" -p status.interval=1 -p recordcount=100000 -p "redis.host=127.0.0.1" -p "redis.port=6379" >> "${OUTPUT_YCSBLOAD_NAME}" 2>> "${OUTPUT_YCSBLOAD_NAME}"

#echo "Now running redis with YCSB driver"
numactl -m 0 taskset -c "${YCSB_CORE}" ${YCSB_DIR}/bin/ycsb run redis -s -P "${YCSB_DIR}/workloads/workloadb" -p status.interval=1 -p operationcount=15000000 -p "redis.host=127.0.0.1" -p "redis.port=6379" >> "${OUTPUT_YCSBRUN_NAME}" 2>> "${OUTPUT_YCSBRUN_NAME}" &

YCSB_PID=$!
#echo YCSB_PID=$YCSB_PID
StopYCSBLog="data/${EXPERIMENT_NAME}.YCSB_PID"

# Run the batch application 1
if [ "x${SUITE}" == "xparsec" ]; then
	run_parsec "${BMARK}" "${BUBBLE_CORE1}" >> "${EXPERIMENT_LOG}" &
	if [ $? -ne 0 ]; then
		echo "Error: Failed to run benchmark"
       	exit 2
	fi
elif [ "x${SUITE}" == "xspec_int" -o "x${SUITE}" == "xspec_fp" ]; then
	run_spec "${BMARK}" "${BUBBLE_CORE1}" >> "${EXPERIMENT_LOG}" &
	if [ $? -ne 0 ]; then
		echo "Error: Failed to run benchmark"
		exit 2
	fi
fi

# Run the batch application 2
if [ "x${SUITE2}" == "xparsec" ]; then
	run_parsec "${BMARK2}" "${BUBBLE_CORE2}" >> "${EXPERIMENT_LOG2}" &
	if [ $? -ne 0 ]; then
        echo "Error: Failed to run benchmark"
        exit 2
	fi
elif [ "x${SUITE2}" == "xspec_int" -o "x${SUITE2}" == "xspec_fp" ]; then
	run_spec "${BMARK2}" "${BUBBLE_CORE2}" >> "${EXPERIMENT_LOG2}" &
	if [ $? -ne 0 ]; then
        echo "Error: Failed to run benchmark"
        exit 2
	fi
fi

# Wait for 90 seconds
sleep 90

# Terminate redis+YCSB as needed
kill $YCSB_PID
pkill -f "ycsb-0.12.0"

kill $REDIS_PID
pkill -f "redis-server"
sleep 10
echo "YCSB+redis stopped, see as follows" > $StopYCSBLog
echo `ps -aux | grep "redis"` >> $StopYCSBLog
echo "----------------------" >> $StopYCSBLog
echo `ps -aux | grep "ycsb"` >> $StopYCSBLog

pkill -f "run_base_refspeed"
pkill -f "cpu2017"
pkill -f "runcpu"
pkill -f "parsec-3.0"
sleep 5
rm -rf ~/cpu2017/benchspec/CPU/*/run
rm -rf ~/PARSEC-3.0/parsec-3.0/pkgs/apps/*/run

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

REPORTER_CURVE="../data/redis_curve.bubble_size.ipc.medians"
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
