#!/bin/bash

BUSID=$( usbip list --local | grep -B 1 "SDRplay" | head -1 | awk '{print $3}' | tee /dev/stderr )

usbip unbind --busid=$BUSID

