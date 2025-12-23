#!/bin/bash

#HOST="sdr0.home.mansfield.co.uk"
HOST="192.168.29.59"
BUSID="1-1.2"

set -x
usbip deattach --busid="$BUSID"
