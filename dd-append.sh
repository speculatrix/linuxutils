#!/bin/bash
# ./dd-append.sh file number-of-MB

FILE="$1"
GROWBY="$2"

if [ ! -f "$FILE" ] ; then
        echo "Error, file does not exist"
        exit 1
fi

MB=$(( 1024 * 1024 ))
#echo "Debug, MB is $MB"

dd if=/dev/urandom "of=$FILE" "bs=$MB" "count=$GROWBY" oflag=append conv=notrunc

