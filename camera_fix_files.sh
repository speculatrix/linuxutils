#!/bin/sh

FILECOUNT=`ls | grep ARW | wc -l`
if [ $FILECOUNT -gt 0 ] ; then
	for X in *ARW
	do
		echo "Renaming ARW to arw"
		Y=`echo $X|sed -e s'/ARW/arw/'`
		mv -n $X $Y
	done
fi

FILECOUNT=`ls | grep AVI | wc -l`
if [ $FILECOUNT -gt 0 ] ; then
	for X in *AVI
	do
		echo "Renaming AVI to avi"
		Y=`echo $X|sed -e s'/AVI/avi/'`
		mv -n $X $Y
	done
fi

FILECOUNT=`ls | grep HIF | wc -l`
if [ $FILECOUNT -gt 0 ] ; then
	for X in *HIF
	do
		echo "Renaming HIF to hif"
		Y=`echo $X|sed -e 's/HIF/hif/'`
		mv -n $X $Y
	done
fi

FILECOUNT=`ls | grep JPG | wc -l`
if [ $FILECOUNT -gt 0 ] ; then
	for X in *JPG
	do
		echo "Renaming JPG to jpg"
		Y=`echo $X|sed -e 's/JPG/jpg/'`
		mv -n $X $Y
	done
fi

FILECOUNT=`ls | grep MOV | wc -l`
if [ $FILECOUNT -gt 0 ] ; then
	for X in *MOV
	do
		echo "Renaming MOV to mov"
		Y=`echo $X|sed -e 's/MOV/mov/'`
		mv -n $X $Y
	done
fi

FILECOUNT=`ls | grep MP4 | wc -l`
if [ $FILECOUNT -gt 0 ] ; then
	for X in *MP4
	do
		echo "Renaming MP4 to mp4"
		Y=`echo $X|sed -e 's/MP4/mp4/'`
		mv -n $X $Y
	done
fi

FILECOUNT=`ls | grep MPO | wc -l`
if [ $FILECOUNT -gt 0 ] ; then
	for X in *MPO
	do
		echo "Renaming MPO to mpo"
		Y=`echo $X|sed -e 's/MPO/mpo/'`
		mv -n $X $Y
	done
fi

FILECOUNT=`ls | grep MTS | wc -l`
if [ $FILECOUNT -gt 0 ] ; then
	for X in *MTS
	do
		echo "Renaming MTS to mts and renaming to date-stamped"
		Y=`echo $X|sed 's/MTS/mts/'`
		mv -n $X $Y
	       	$HOME/bin/renamefilebydate.pl -a -1080p $Y
	done
fi

FILECOUNT=`ls | grep -E "thm|THM" | wc -l`
if [ $FILECOUNT -gt 0 ] ; then
	for X in *thm *THM
	do
		echo "Renaming THM or thm to jpg"
		Y=`echo $X|sed -e 's/thm/jpg/' -e 's/THM/jpg/'`
		mv -n $X $Y
	done
fi

FILECOUNT=`ls | grep RW2 | wc -l`
if [ $FILECOUNT -gt 0 ] ; then
	for X in *RW2
	do
		echo "Renaming RW2 to rw2"
		Y=`echo $X|sed 's/RW2/rw2/'`
		mv -n $X $Y
	done
fi


