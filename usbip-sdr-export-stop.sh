#!/bin/bash

usbip list --local | grep -B 1 "SDRplay" | head -1 | awk '{print $3}'

usbip detach --busid="$BUSID"
