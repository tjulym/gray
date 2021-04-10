#!/usr/bin/env bash

set -ex

# Create a directory for binaries
[ -d bin ] || mkdir bin/


# Build memory subsystem rulers
for file in src/bubbles/*.c
do
  echo "Build ${file} ..."
  base_f=`basename ${file}`
  gcc "${file}" -static -lrt -lpthread -o "bin/static_${base_f%.c}"
done

gcc "src/bubbles/bubble.c" -O1 -static -lrt -lpthread -o "bin/static_bubble"

for SIZE in 524288 1048576 2097152 4194304 8338608 16777216 33554423
do
  echo "Building reporter of size ${SIZE}"
  gcc "src/bubbles/reporter.c" -static -lrt -DFOOTPRINT=${SIZE} -o "bin/static_reporter_${SIZE}"
done
