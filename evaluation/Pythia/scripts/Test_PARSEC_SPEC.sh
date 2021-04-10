#!/bin/bash

#for SUITE in parsec; do
#	for BMARK in `cat "single_app_contention/manifests/${SUITE}_benchmarks"`; do
#        numactl -m 0 taskset -c 0 parsecmgmt -a run -i native -n 1 -p "${BMARK}" &
#        sleep 10
#        pkill -f "parsec"
#        sleep 5
#	done
#done

for SUITE in spec_int ; do
	for BMARK in "625"; do
        numactl -m 0 taskset -c 0 runcpu --config=/home/Pythia/cpu2017/config/Ran.cfg --action=run --size=ref "${BMARK}" &
        sleep 30
pkill -f "run_base_refspeed"
pkill -f "cpu2017"
pkill -f "runcpu"
echo "_______________________"
echo "Finish " $BMARK ". Sleep 5 seconds and continue."
        sleep 5
	done
done

exit

ps -aux > tmp.txt

