#!/bin/bash

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
