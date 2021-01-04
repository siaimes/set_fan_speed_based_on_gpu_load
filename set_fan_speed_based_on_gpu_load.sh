#!/bin/bash

GPUNUM=$(nvidia-smi -q | grep "GPU Current Temp" | wc -l)
while true; do
    MAXTEMP=0
    for i in $(seq 1 "$GPUNUM"); do
        CUR=$(nvidia-smi -q | grep "GPU Current Temp" | awk '{print $5}' | sed -n "${i}p")
        if [ "$CUR" -gt "$MAXTEMP" ]; then
            MAXTEMP="$CUR"
        fi
    done
    eval "ipmitool raw 0x38 0x14 0x06 0x$MAXTEMP > /dev/null"
    sleep 10s
done
