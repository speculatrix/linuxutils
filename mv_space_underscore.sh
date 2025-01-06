#!/bin/bash

# can't do for X in * because end up with split file names

mapfile -t FILELIST < <( ls )
for FILENAME in "${FILELIST[@]}" ; do
	echo "$FILENAME" | grep -q " "
	if [ $? -eq 0 ] ; then
		NEWFILENAME=$( echo $FILENAME | tr ' ' '_'  )
		echo "mv \"$FILENAME\" \"$NEWFILENAME\""
		mv "$FILENAME" "$NEWFILENAME"
	fi
done

