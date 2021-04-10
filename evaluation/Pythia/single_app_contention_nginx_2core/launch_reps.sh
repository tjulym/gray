#!/bin/bash
# run by: sudo numactl -m 0 taskset -c 11 bash launch_reps.sh 1 2
#
# Run REPS repetitions of the experiment on the cab cluster
#

REPS=$1
CORES=$2

echo "Launching ${REPS} reps with cores ${CORES}..." 1>&2

for REP in `seq 1 ${REPS}`; do
    # Generate experiment list
    ./create_experiment.sh "${REP}" "${CORES}" > "experiment_list.${REP}"

    echo "Launching rep ${REP}..." 1>&2
    python ./run_experiments.py ${REP}

    if [ $? -ne 0 ]; then
        echo "Error: Failed to submit rep ${REP}" 1>&2
        exit 1    
    fi
    echo "Launched rep ${REP}" 1>&2
done
sudo chmod 666 experiment_list.*
sudo chmod 666 completed_experiments.*
sudo chmod 666 data/*
sudo chmod 666 logs/*
