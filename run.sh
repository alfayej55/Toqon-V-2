#!/bin/bash
# Run Flutter with filtered Android system logs
# Usage: ./run.sh [device_id]
# Example: ./run.sh 0B04905X2000156C

DEVICE_FLAG=""
if [ -n "$1" ]; then
    DEVICE_FLAG="-d $1"
fi

flutter run $DEVICE_FLAG 2>&1 | grep -v \
    -e "BufferQueueProducer" \
    -e "SurfaceView" \
    -e "queueBuffer" \
    -e "addAndGetFrameTimestamps" \
    -e "BLAST Consumer" \
    -e "dataSpace=" \
    -e "validHdrMetadataTypes" \
    -e "crop=\[" \
    -e "transform=0" \
    -e "scale=SCALE" \
    -e "slot=[0-9]" \
    -e "id:[0-9a-f]" \
    -e "api:1,p:" \
    -e "time=[0-9]"