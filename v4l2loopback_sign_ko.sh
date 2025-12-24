#!/bin/bash
# In Fedora, the kernel module v4l2loopback isn't signed, and can't be
# loaded into the kernel if you're running a secure system.
# Signing the module requires it to be decompressed, signed, and then
# recompressed.
# in due course, I will commit a script for creating a signing key to
# make things easy for you.

KVER=$(uname -r)
SIGNER="mok"
DKMS_DIR="$HOME/dkms"

if [ -f "/lib/modules/$KVER/extra/v4l2loopback/v4l2loopback-unsigned.ko.xz" ] ; then
	echo "Error, the presence of v4l2loopback-unsigned.ko.xz suggests the module has already been signed"
	exit 1
fi

if [ -f "/lib/modules/$KVER/extra/v4l2loopback/v4l2loopback.ko" ] ; then
	echo "Error, the presence of v4l2loopback.ko suggests the previous signing attempt went wrong"
	exit 1
fi

echo "# Files before"
ls -la "/lib/modules/$KVER/extra/v4l2loopback/" | grep v4l2loop
md5sum /lib/modules/$KVER/extra/v4l2loopback/*v4l2loop*

### save and decompress the unsigned kernel module
mv "/lib/modules/$KVER/extra/v4l2loopback/v4l2loopback.ko.xz" "/lib/modules/$KVER/extra/v4l2loopback/v4l2loopback-unsigned.ko.xz"
xz -d < "/lib/modules/$KVER/extra/v4l2loopback/v4l2loopback-unsigned.ko.xz" > "/lib/modules/$KVER/extra/v4l2loopback/v4l2loopback.ko"

### sign the kernel module
"/usr/src/kernels/$KVER/scripts/sign-file" sha256 "$DKMS_DIR/$SIGNER.priv" "$DKMS_DIR/$SIGNER.der" "/lib/modules/$KVER/extra/v4l2loopback/v4l2loopback.ko"

if [ -f "/lib/modules/$KVER/extra/v4l2loopback/v4l2loopback.ko" ] ; then
	echo "Ok, v4l2loopback.ko exists"
	if [ ! -s "/lib/modules/$KVER/extra/v4l2loopback/v4l2loopback.ko" ] ; then
		echo "Error, the v4l2loopback.ko was an empty file"
		exit 1
	fi
fi

### compress the signed module, the .ko is removed leaving the ko.xz
xz "/lib/modules/$KVER/extra/v4l2loopback/v4l2loopback.ko"

echo "# Files before depmod"
ls -la "/lib/modules/$KVER/extra/v4l2loopback/" | grep v4l2loop
md5sum /lib/modules/$KVER/extra/v4l2loopback/*v4l2loop*

depmod -a

echo "# Files After"
ls -la "/lib/modules/$KVER/extra/v4l2loopback/" | grep v4l2loop
md5sum /lib/modules/$KVER/extra/v4l2loopback/*v4l2loop*

# end v4l2loopback_sign_ko.sh
