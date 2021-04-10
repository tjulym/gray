#!/bin/bash

for BENCHMARK in `cat manifests/parsec_benchmarks`; do
	echo "Building parsec_${BENCHMARK}..."
	parsecmgmt -a build -p "${BENCHMARK}" 2>&1 > output
	if [ $? -ne 0 ]; then
		echo "Error: Failed to build ${BENCHMARK}"
		exit 1
	fi
	echo "Built parsec_${BENCHMARK}"
done

for BENCHMARK in `cat manifests/spec_int_benchmarks`; do
	echo "Building spec_int_${BENCHMARK}..."
	runspec --action setup --config research_config --size ref "${BENCHMARK}" 2>&1 > output
	if [ $? -ne 0 ]; then
		echo "Error: Failed to build ${BENCHMARK}"
		exit 1
	fi
	echo "Built spec_int_${BENCHMARK}"
done

for BENCHMARK in `cat manifests/spec_fp_benchmarks`; do
	echo "Building spec_fp_${BENCHMARK}..."
	runspec --action setup --config research_config --size ref "${BENCHMARK}" 2>&1 > output
	if [ $? -ne 0 ]; then
		echo "Error: Failed to build ${BENCHMARK}"
		exit 1
	fi
	echo "Built spec_fp_${BENCHMARK}"
done
