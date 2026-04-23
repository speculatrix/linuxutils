#!/bin/bash
# sysinfo script

export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin

HOSTNAME=`/bin/hostname`
DATE=`date +%Y%m%d-%H%M%S`
DIR=/root/sysinfo-`/bin/uname -n`

mkdir -p $DIR

/bin/df -k > $DIR/df-k-$DATE.txt 2>&1
/sbin/fdisk -l -u > $DIR/fdisk-l-u-$DATE.txt 2>&1

if [ -f /bin/rpm ] ; then
	/bin/rpm -qa | sort > $DIR/rpm-qa-$DATE.txt 2>&1
elif [ -f /usr/bin/dpkg ] ; then
	dpkg -l > $DIR/dpkg-l-$DATE.txt 2>&1
else
	echo "Error, package manager unknown"
fi

systemctl > $DIR/systemctl-$DATE.txt 2>&1
mount > $DIR/mount-$DATE.txt

/bin/cat /proc/mdstat > $DIR/proc_mdstat-$DATE.txt 2>&1
/sbin/mdadm --detail --scan > $DIR/mdadm-detail-scan-$DATE.txt 2>&1

cd /dev
for DD in nvme0n? ; do
	smartctl -a $DD > $DIR/smartctl-$DD-$DATE
done


grep -E -v "^#|^$" /etc/crypttab | (
	while read X Y Z
	do
		if [ "$X" != "" -a "$Y" != "" -a "$Z" != "" ] ; then
			#echo "'$X' '$Y' '$Z'"
			if [ -L $Y ] ; then
				echo "Saving luks key for map $X device $Y"
				/sbin/cryptsetup luksHeaderBackup --header-backup-file $DIR/$X.luksheader.$DATE.txt $Y
			#else
				#echo "Device $Y is not connected"
			fi
		else
			error, "entry bogus entry in crypttab $X $Y $Z"
		fi
	done
)


#exit


cd /dev/mapper
ls | grep cr_ > /dev/null
if [ $? -eq 0 ] ; then
	for X in cr_*
	do
		echo "Saving luks key for $X"
		#/sbin/cryptsetup luksHeaderBackup --header-backup-file $DIR/$X.luksheader.$DATE.txt /dev/mapper/$X
		/sbin/dmsetup table --target crypt --showkey /dev/mapper/$X  > /root/sysinfo-$HOSTNAME/$X.luks-key.$DATE.txt
	done
else
	echo "no luks device found"
fi

# end sysinfo script
