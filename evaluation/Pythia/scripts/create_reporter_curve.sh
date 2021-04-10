#!/bin/bash

BUBBLE_CORE=2
REPORTER_CORE=1

# Generates reporter curve by running the reporter and bubble side by side

EXPERIMENT_NAME="reporter_curve"
BINARY_DIR="bin"
PID_FILE="${EXPERIMENT_NAME}.pid"
OUTPUT_NAME="data/${EXPERIMENT_NAME}.reporter.perf_counters"

# Launch the reporter in the background
# Intervals of 1 seconds for the outputs (delay 100 milliseconds to start)
"${BINARY_DIR}/time" 2> "${OUTPUT_NAME}" | 3>>"${OUTPUT_NAME}" numactl -m 0 taskset -c "${REPORTER_CORE}" perf stat -I 1000 -e cycles,instructions --log-fd=3 -x ' ' "${BINARY_DIR}/reporter" 1> "${EXPERIMENT_NAME}.pid" &
if [ $? -ne 0 ]; then
    echo "Error: Failed to start perf and reporter"
    exit 1
fi

BUBBLE_SIZE_FILE="data/${EXPERIMENT_NAME}.bubble.size"
BUBBLE_PERF_COUNTERS="data/${EXPERIMENT_NAME}.bubble.perf_counters"

# Start the bubble
# The time binary is run first to generate an absolute timestamp at the beginning
# The perf util output will contain relative offsets that will be added to the absolute
# initial timestamp and the post-processing script will perform registration between
# the reporter timestamps and the bubble timestamps
"${BINARY_DIR}/time" 2> "${BUBBLE_PERF_COUNTERS}" && 3>> "${BUBBLE_PERF_COUNTERS}" numactl -m 0 taskset -c "${BUBBLE_CORE}" perf stat --log-fd=3 -e instructions,cycles -I 600 "${BINARY_DIR}"/bubble 1.25 12000 1 |& tee "${BUBBLE_SIZE_FILE}"
if [ $? -ne 0 ]; then
	echo "Error: Failed to run bubble"
	exit 2
fi

# Terminate the reporter once the bubble finishes running
kill `cat "${PID_FILE}"`
rm "${PID_FILE}"

# Run the post-processing script on the output
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
