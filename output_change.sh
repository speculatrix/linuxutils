#!/bin/bash

FILE_OLD=$( mktemp /tmp/output_change_XXXXXX.old.txt )
FILE_NEW=$( mktemp /tmp/output_change_XXXXXX.new.txt )

CMD="$*"

touch "$FILE_OLD"
while /bin/true ; do
	/bin/date | tr -d "\n" 
	echo -n "   "
	$CMD > "$FILE_NEW"
	#if cmp -s "$FILE_OLD" "$FILE_NEW" ; then
	diff "$FILE_OLD" "$FILE_NEW"
	#fi
	sleep 2
	cp -p "$FILE_NEW" "$FILE_OLD"
done

