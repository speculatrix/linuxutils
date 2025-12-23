#!/bin/bash

BUSID="1-1.2"

set -x
usbip deattach --busid="$BUSID"
