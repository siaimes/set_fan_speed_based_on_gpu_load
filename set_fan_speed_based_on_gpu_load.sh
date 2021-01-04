#!/bin/bash

OLD=0
while true; do
    MAXTEMP=$({(nvidia-smi -q | grep "GPU Current Temp" | awk '{print $5}') && \
    (ipmitool sdr list | grep -w TEMP_CPU. | awk '{print $3}')} | \
    awk '{if(max=="") {max=$1}; if($1>max) {max=$1}} END {print max}')
    if [ "$OLD" -ne "$MAXTEMP" ]; then
        eval "ipmitool raw 0x38 0x14 0x06 0x$MAXTEMP > /dev/null"
        OLD=$MAXTEMP
    fi
    sleep 10s
done
