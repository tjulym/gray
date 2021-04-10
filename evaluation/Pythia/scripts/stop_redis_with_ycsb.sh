#!/bin/bash

REDIS_DIR="./apps/redis"

cd multi_app_with_qos
bash "$REDIS_DIR/stop.sh" "$REDIS_DIR/tmp"

pkill -f "redis-server"
