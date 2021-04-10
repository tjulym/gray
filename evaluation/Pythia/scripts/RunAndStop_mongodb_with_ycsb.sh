#!/bin/bash

CurrentDir=`pwd`
MONGODB_DIR="$CurrentDir/multi_app_with_qos/apps/mongodb"
YCSB_DIR="/media/xu943/disk2/ycsb-0.12.0"

## Prepare 
cd "$CurrentDir/multi_app_with_qos"
mkdir "$MONGODB_DIR/tmp"; rm "$MONGODB_DIR/tmp/*";

## Start Redis server
bash "$MONGODB_DIR/start.sh" "$MONGODB_DIR/tmp" &
echo "Sleep 5 seconds for init"  
sleep 5 

## Start YCSB benchmark
echo "Now loading mongodb with YCSB data"
${YCSB_DIR}/bin/ycsb load mongodb-async -s -P "${YCSB_DIR}/workloads/workloadb" -p recordcount=100000 | tee ../outputLoad.txt

echo "Now running mongodb with YCSB driver"
${YCSB_DIR}/bin/ycsb run mongodb-async -s -P "${YCSB_DIR}/workloads/workloadb" -p operationcount=100000 | tee ../outputRun.txt
#$YCSB_DIR/bin/ycsb run redis -s -P workloads/workloada | tee outputRun.txt

## Stop Mongodb server
echo "Stop Mongodb"
cd "$CurrentDir/multi_app_with_qos"
bash "$MONGODB_DIR/stop.sh" "$MONGODB_DIR/tmp"

exit



##################### For the use of debugging #################################
cd /home/xu943/co-location/LLNL-DCSL-PerformancePrediction/multi_app_with_qos
bash "/home/xu943/co-location/LLNL-DCSL-PerformancePrediction/multi_app_with_qos/apps/mongodb/start.sh" "/home/xu943/co-location/LLNL-DCSL-PerformancePrediction/multi_app_with_qos/apps/mongodb/tmp" &
/media/xu943/disk2/ycsb-0.12.0/bin/ycsb load mongodb-async -s -P "/media/xu943/disk2/ycsb-0.12.0/workloads/workloadb" -p recordcount=100000 | tee outputLoad.txt

/media/xu943/disk2/ycsb-0.12.0/bin/ycsb run mongodb-async -s -P "/media/xu943/disk2/ycsb-0.12.0/workloads/workloadb" -p operationcount=1000000  | tee outputRun.txt

# Kill mongodb
bash "/home/xu943/co-location/LLNL-DCSL-PerformancePrediction/multi_app_with_qos/apps/mongodb/stop.sh" "/home/xu943/co-location/LLNL-DCSL-PerformancePrediction/multi_app_with_qos/apps/mongodb/tmp"
cat ~/co-location/LLNL-DCSL-PerformancePrediction/multi_app_with_qos/apps/mongodb/tmp/app.pid
ps -aux | grep "mongodb"
ps -aux | grep "ycsb"
netstat -an | grep "28017"
################################################################################

