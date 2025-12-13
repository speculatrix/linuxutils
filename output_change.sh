#!/bin/bash

FILE_OLD=$( mktemp /tmp/output_change_XXXXXX.old.txt )
FILE_NEW=$( mktemp /tmp/output_change_XXXXXX.new.txt )

CMD="$*"

touch "$FILE_OLD"
while /bin/date ; do
	$CMD > "$FILE_NEW"
	diff "$FILE_OLD" "$FILE_NEW"
	sleep 2
	cp -p "$FILE_NEW" "$FILE_OLD"
done

