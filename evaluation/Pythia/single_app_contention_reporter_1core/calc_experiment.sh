#!/bin/bash

# Need Python version with SciKit Learn installed
PYTHON="/usr/bin/python"

#
# INPUT: suite bmark rep cores
#

#
# OUTPUT: time mean_ipc estimated_bubble_mean median_ipc estimated_bubble_median
#

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

# Perform processing out the output data
../processing/process_perf.py "data/${EXPERIMENT_NAME}.reporter" "${OUTPUT_NAME}" &>> "${EXPERIMENT_LOG}"
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

REPORTER_CURVE="../data/reporter_curve.bubble_size.ipc.medians"
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
