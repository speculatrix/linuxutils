#!/bin/bash

for f_old in "${@}" ; do
	echo "Info, considering file $f_old"
	filename="${f_old%.*}"
	ext="${f_old##*.}"
	if echo "$ext" | grep -q -E "[A-Z]" ; then
		#echo "Dbg, $f_old - $filename extension $ext has upper case chars "
		ext_lc=$( echo "$ext" | tr '[:upper:]' '[:lower:]' )
		f_new="${filename}.${ext_lc}"
		if [ ! -f "$f_old" ] ; then
			echo "Error, origin file $f_old doesn't exist"
		elif [ -f "$f_new" ] ; then
			echo "Error, target file $f_new already exists"
		else
			mv -n "$f_old" "$f_new"
		fi
	fi
done
