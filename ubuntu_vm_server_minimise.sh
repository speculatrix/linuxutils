#!/bin/bash

echo "removing packages not needed on an ubuntu server vm"

PKGS="iw snapd eject dmidecode eatmydata hdparm fuse libeatmydata1 libfuse2 dosfstools squashfstools ufw open-vm-tools ntfs-3g wireless-regdb bolt   alsa-topology-conf alsa-ucm-conf amd64-microcode fwupd fwupd-signed  crda gsettings-desktop-schemas ethtool lxd-loader lxd-agent-loader iucode-tool"

dpkg -r $PKGS
dpkg -P $PKGS
