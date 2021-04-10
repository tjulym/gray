#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Error: Invalid number of parameters"
	echo "create_experiment.sh REP CORES"
	exit 1
fi

REP=$1
shift
CORES=$1

SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

for SUITE in parsec spec_fp spec_int; do
	for BMARK in `cat "${SCRIPT_DIR}/manifests/${SUITE}_benchmarks"`; do
        echo "${SUITE} ${BMARK} ${REP} ${CORES}"
	done
done
