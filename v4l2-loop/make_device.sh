#!/bin/bash
# https://devevangelista.medium.com/immersed-linux-life-bc2e2661c7aa
rmmod v4l2loopback
depmod -a
modprobe v4l2loopback card_label='Immersed Cam' video_nr=77 exclusive_caps=1
# edit the ./Immersed-x86_64.AppImage and set 
# CameraDevice=/dev/video77
v4l2loopback-ctl list
v4l2-ctl -A

