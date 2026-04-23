#!/bin/bash

if [ "$1" == "" ] ; then
	echo "Error, minimal usage requires a directory argument"
fi

if [ -d "$1" ] ; then
	echo "Error, $1 is not a directory"
fi

if [ "$2" != "" ] ; then
	DIR1="$1"	# user supplied both directories
	DIR2="$2"
else
	DIR1="."	# user supplied just the "remote" directory
	DIR2="$1"
fi

echo "Debug, comparing '$DIR1' with '$DIR2'"

cd "$DIR1"
find . -type f | \
	grep -v .git/ | \
	while read FF ; do
		echo "=== $FF ==="
		diff "$FF" "$DIR2/$FF"
	done

