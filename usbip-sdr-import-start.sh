#!/bin/bash

#HOST="sdr0.home.mansfield.co.uk"
HOST="192.168.29.59"
BUSID="1-1.2"
#BUSID="1-1"
MODULES=( usbip_core vhci_hcd )

for MODULE in "${MODULES[@]}" ; do
	lsmod | grep -q "$MODULE"
	if [ $? -ne 0 ] ; then
	        echo "Error, please modprobe $MODULE"
	        exit 1
	fi
done

usbip list -r "$HOST"
set -x
usbip attach -r "$HOST" --busid="$BUSID"
