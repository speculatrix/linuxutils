#!/bin/bash
# uses stat to find the last modified date of a file and then
# works out the dage in seconds
# passes shellcheck

state_file="file_age.sh"

if [ -f "$state_file" ] ; then
	was=$( stat --printf="%Y" "$state_file" )
	now=$( date +%s )

	age=$(( now - was ))

	echo "age in secs $age"
fi
