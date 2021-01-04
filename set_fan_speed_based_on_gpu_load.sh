#!/bin/bash

GPUNUM=$(nvidia-smi -q | grep "GPU Current Temp" | wc -l)
CPUNUM=$(ipmitool sdr list | grep -w TEMP_CPU. | wc -l)
OLD=0
while true; do
    MAXTEMP=0
    for i in $(seq 1 "$GPUNUM"); do
        CUR=$(nvidia-smi -q | grep "GPU Current Temp" | awk '{print $5}' | sed -n "${i}p")
        if [ "$CUR" -gt "$MAXTEMP" ]; then
            MAXTEMP="$CUR"
        fi
    done
    for i in $(seq 1 "$CPUNUM"); do
        CUR=$(ipmitool sdr list | grep -w TEMP_CPU. | awk '{print $3}' | sed -n "${i}p")
        if [ "$CUR" -gt "$MAXTEMP" ]; then
            MAXTEMP="$CUR"
        fi
    done
	echo $MAXTEMP
	if [ "$OLD" -ne "$MAXTEMP" ]; then
        eval "ipmitool raw 0x38 0x14 0x06 0x$MAXTEMP > /dev/null"
		OLD=$MAXTEMP
	fi
    sleep 10s
done
