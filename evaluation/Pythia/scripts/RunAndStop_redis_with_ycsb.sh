#!/bin/bash

CurrentDir="/home/xu943/co-location/LLNL-DCSL-PerformancePrediction"
REDIS_DIR="$CurrentDir/multi_app_with_qos/apps/redis"
YCSB_DIR="/media/xu943/disk2/ycsb-0.12.0"

## Prepare 
cd "$CurrentDir/multi_app_with_qos"
mkdir "$REDIS_DIR/tmp"; rm "$REDIS_DIR/tmp/*";

## Start Redis server
bash "$REDIS_DIR/start.sh" "$REDIS_DIR/tmp" &
echo "Sleep 5 seconds for init"  
sleep 5 

## Start YCSB benchmark
echo "Now loading redis with YCSB data"
${YCSB_DIR}/bin/ycsb load redis -s -P "${YCSB_DIR}/workloads/workloadb" -p recordcount=100000 -p "redis.host=127.0.0.1" -p "redis.port=6379" | tee ../outputLoad.txt

echo "Now running redis with YCSB driver"
${YCSB_DIR}/bin/ycsb run redis -s -P "${YCSB_DIR}/workloads/workloadb" -p operationcount=1500000 -p "redis.host=127.0.0.1" -p "redis.port=6379" | tee ../outputRun.txt
#$YCSB_DIR/bin/ycsb run redis -s -P workloads/workloada | tee outputRun.txt

## Stop Redis server
echo "Stop redis"
cd "$CurrentDir/multi_app_with_qos"
bash "$REDIS_DIR/stop.sh" "$REDIS_DIR/tmp"

exit



##################### For the use of debugging #################################
cd /home/xu943/co-location/LLNL-DCSL-PerformancePrediction/multi_app_with_qos
bash "/home/xu943/co-location/LLNL-DCSL-PerformancePrediction/multi_app_with_qos/apps/redis/start.sh" "/home/xu943/co-location/LLNL-DCSL-PerformancePrediction/multi_app_with_qos/apps/redis/tmp"
/media/xu943/disk2/ycsb-0.12.0/bin/ycsb load redis -s -P "/media/xu943/disk2/ycsb-0.12.0/workloads/workloadb" -p recordcount=100000 -p operationcount=15000000 -p "redis.host=127.0.0.1" -p "redis.port=6379" | tee outputLoad.txt

cat ~/co-location/LLNL-DCSL-PerformancePrediction/multi_app_with_qos/apps/redis/tmp/app.pid
ps -aux | grep "redis"
ps -aux | grep "ycsb"
netstat -an | grep "6379"
################################################################################

