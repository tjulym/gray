#!/bin/bash

# Need Python version with SciKit Learn installed
PYTHON="/usr/bin/python"
parsecmgmt_path="/home/Pythia/PARSEC-3.0/parsec-3.0/bin/parsecmgmt"
runcpu_path="/home/Pythia/cpu2017/bin/runcpu"
#
# INPUT: suite bmark rep cores
#

#
# OUTPUT: time mean_ipc estimated_bubble_mean median_ipc estimated_bubble_median
#

#
# NOTE: The taskset calls must be updated to reflect the appropriate processor topology
#
SIEGE_CORE="10"
BUBBLE_CORE="2-3"
REPORTER_CORE="0-1"

function run_parsec() {
	BMARK=$1
	CORES=$2
	numactl -m 0 taskset -c $BUBBLE_CORE "$parsecmgmt_path" -a run -i native -n "${CORES}" -p "${BMARK}" > "${EXPERIMENT_LOG}"
}

function run_spec() {
	BMARK=$1
	numactl -m 0 taskset -c $BUBBLE_CORE "$runcpu_path" --config=/home/Pythia/cpu2017/config/Ran.cfg --action=run --size=ref "${BMARK}" > "${EXPERIMENT_LOG}"
}

function run_additional() {
	BMARK=$1
	if [ "x${BMARK}" == "xinmem" ]; then
		DATA_NAME="data"
		APP_NAME="in-mem"
		sudo docker create --name ${DATA_NAME} --cpuset-cpus=${BUBBLE_CORE} --cpuset-mems="0" cloudsuite/movielens-dataset > tmp.txt
		sudo docker run -d --rm --name ${APP_NAME} --cpuset-cpus=${BUBBLE_CORE} --cpuset-mems="0" --volumes-from ${DATA_NAME} cloudsuite/in-memory-analytics /data/ml-latest /data/myratings.csv --driver-memory 4g --executor-memory 4g > tmp.txt
	else
		DATA_NAME="data"
		APP_NAME="graph"
		sudo docker create --name ${DATA_NAME} --cpuset-cpus=${BUBBLE_CORE} --cpuset-mems="0" cloudsuite/twitter-dataset-graph > tmp.txt
		sudo docker run -d --rm --name ${APP_NAME} --cpuset-cpus=${BUBBLE_CORE} --cpuset-mems="0" --volumes-from ${DATA_NAME} cloudsuite/graph-analytics --driver-memory 4g --executor-memory 4g > tmp.txt
	fi
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

# Launch the nginx in the background
#sudo nginx -s stop

sudo numactl -m 0 taskset -c ${REPORTER_CORE} nginx
sudo "../bin/time" 2>${OUTPUT_NAME} && sudo perf stat -x " " -I 1000 -e cycles,instructions -p $(echo `pgrep nginx` | sed -e "s/ /,/g") 2>> ${OUTPUT_NAME} &

#echo "Sleep 5 seconds for init"  
sleep 5 

## Start SIEGE
cd "$CurrentDir"
sudo numactl -m 0 taskset -c ${SIEGE_CORE} siege -q -c 1000 -log=/dev/null localhost/big_image.jpg >data/siege_output.txt 2>&1 &

#echo "Sleep 5 seconds for init"  
sleep 5 

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
elif [ "x${SUITE}" == "xadditional" ]; then
	run_additional "${BMARK}" &
	if [ $? -ne 0 ]; then
		echo "Error: Failed to run benchmark"
        kill `cat "${PID_FILE}"`
        rm "${PID_FILE}"
		exit 2
	fi
fi

# Wait for 90 seconds
sleep 90

# Terminate the Siege
#echo "Stop Siege"
sudo pkill -f siege
#kill $YCSB_PID
sleep 5

## Stop nginx server
#echo "Stop nginx"
sudo pkill -f perf
sleep 5
sudo nginx -s stop
sleep 5

sudo docker kill $(docker ps -q) > tmp.txt
sudo docker rm $(docker ps -a -q) > tmp.txt

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

REPORTER_CURVE="../data/nginx_curve.bubble_size.ipc.medians"
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

sudo chmod 666 data/*

# Output final result over stdout
echo "0 ${MEAN_IPC} ${BUBBLE_MEAN} ${MEDIAN_IPC} ${BUBBLE_MEDIAN} ${P95_IPC} ${BUBBLE_P95} ${P99_IPC} ${BUBBLE_P99}"

exit 0
