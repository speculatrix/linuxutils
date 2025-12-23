#!/bin/bash

lsmod | grep -q usbip_host
if [ $? -ne 0 ] ; then
	echo "Error, please modprobe usbip_host"
	exit 1
fi

ps -efwl | grep -v grep | grep -q usbipd
if [ $? -ne 0 ] ; then
	echo "Error, please start usbipd"
	echo "nohup /usr/sbin/usbipd &"
	exit 1
fi

usbip list --local

