#!/bin/bash
HOST_INFO=host.info
for IP in $(awk '/^[^#]/{print $1}' $HOST_INFO);do
    USER=$(awk '/^[^#]/{print $2}' $HOST_INFO)
    PORT=$(awk '/^[^#]/{print $3}' $HOST_INFO)
    TMP_FILE=/tmp/disk.TMP_FILE
    ssh -p $PORT $USER@$IP 'df -h' > $TMP_FILE
    USE_PART_LIST=$(awk 'BEGIN{OFS="="}/^\/dev/{print $1,int($5)}' $TMP_FILE)
    for USE_RATE in $USE_PART_LIST;do
        PART_NAME=${USE_RATE%=*}
        USE_RATE=${USE_RATE#*=}
        if [ $USE_RATE -lt 80 ];then
            echo "Warning: $PART_NAME Partition usage $USE_RATE%!"
        fi
    done
done