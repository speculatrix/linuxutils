#!/bin/bash

DIR="/home/paulm/galleries/2026/20260220"
FILE_PFX="PGII2356"

WIDTH_ORIG=5776
WIDTH_CROP=$((   WIDTH_ORIG  / 2))

HEIGHT_ORIG=4336
HEIGHT_OFFSET=$(( HEIGHT_ORIG     / 5 ))
HEIGHT_CROP=$((   HEIGHT_ORIG * 3 / 5 ))


ls -la "$DIR"

FILE_ORIG="${FILE_PFX}.jpg"
FILE_L="${FILE_PFX}_L.jpg"
FILE_R="${FILE_PFX}_R.jpg"

cd "$DIR" || exit 1

#if [ ! -f "$FILE_L" ] ; then
#	cp "$FILE_ORIG" "$FILE_L"
#fi
#if [ ! -f "$FILE_R" ] ; then
#	cp "$FILE_ORIG" "$FILE_R"
#fi
#exit 1

set -x
magick convert ${FILE_ORIG} -crop ${WIDTH_CROP}x${HEIGHT_CROP}+0+${HEIGHT_OFFSET}		"${FILE_PFX}_L.jpg"

magick convert ${FILE_ORIG} -crop ${WIDTH_CROP}x${HEIGHT_CROP}+${WIDTH_CROP}+${HEIGHT_OFFSET}	"${FILE_PFX}_R.jpg"

