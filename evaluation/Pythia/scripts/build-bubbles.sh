#!/usr/bin/env bash

set -ex

# Create a directory for binaries
[ -d bin ] || mkdir bin/


# Build memory subsystem rulers
for file in src/bubbles/*.c
do
  echo "Build ${file} ..."
  base_f=`basename ${file}`
  gcc "${file}" -lrt -lpthread -o "bin/${base_f%.c}"
done

gcc "src/bubbles/bubble.c" -O1 -lrt -lpthread -o "bin/bubble"

for SIZE in 524288 1048576 2097152 4194304 8338608 16777216 33554423
do
  echo "Building reporter of size ${SIZE}"
  gcc "src/bubbles/reporter.c" -lrt -DFOOTPRINT=${SIZE} -o "bin/reporter_${SIZE}"
done
