#!/bin/bash

set -e

if [[ "$1" = "-q" ]]
then
	SILENT=1
	shift
else
	SILENT=0
fi

if [[ "$2" = "" ]]
then
	echo usage: $0 INPUT.png OUTPUT_NAME [VENDOR]
	exit 1
fi

VENDOR="Anonymous"
if [[ "$3" != "" ]]
then
	VENDOR="$3"
fi

# Size of canvas is 512x256 (ratio 2:1)
# Size of canvas excl. frame is 
# 476x228, since this is a weird
# apsect ratio, we use 472x236 instead
# so we have 2:1 again.
SIZE=472x236
LEVEL="0%,100%,0.5"

if [[ $1 == transform_* ]]; then
    NAME=$1
else
    NAME=$1
    test -f "$1" || NAME=region-flags/png/$1.png
fi

DEST="build/png/($VENDOR)$2"

test $SILENT -eq 0 && echo Processing $1 $2
test $SILENT -eq 0 && set -x
test -d build || bash ./prepare.sh
export TEMP=$(mktemp -d)

if [[ $NAME == transform_* ]]; then
	cat assets/SOURCE_DEFAULT.txt > $TEMP/comment.tmp
	source extra-flags/transform.sh
	"$NAME" "build/$1.png"
	magick convert "build/$1.png" $TEMP/tmp-flag-plain.miff
else
	magick convert $NAME -resize "$SIZE!" $TEMP/tmp-flag-plain.miff
	if [[ -r "$1.txt" ]]
	then
		cat "$1.txt" > $TEMP/comment.tmp
	else
		cat assets/SOURCE_DEFAULT.txt > $TEMP/comment.tmp
	fi
fi
cat assets/SOURCE_TAIL.txt >> $TEMP/comment.tmp
tr '\n' ' ' < $TEMP/comment.tmp | sed 's/ [ ]*/ /g' > $TEMP/comment.txt

magick convert build/fabric.miff -crop '+18+14+0+0' $TEMP/tmp-fabric.miff
magick convert $TEMP/tmp-flag-plain.miff -alpha on -channel A -evaluate multiply 0.9 +channel $TEMP/tmp-flag-alpha.miff
magick composite -compose blend $TEMP/tmp-fabric.miff $TEMP/tmp-flag-alpha.miff $TEMP/tmp-flag-with-fabric.miff
magick $TEMP/tmp-flag-with-fabric.miff -level $LEVEL $TEMP/tmp-flag-with-fabric-dark.miff
magick convert $TEMP/tmp-flag-with-fabric-dark.miff -gravity North -chop 0x4 -gravity South -chop 0x4 $TEMP/tmp-flag-with-fabric-dark-cropped.miff
magick composite -geometry +18+14 $TEMP/tmp-flag-with-fabric-dark-cropped.miff build/blank.miff $TEMP/tmp-flag-offset.miff
magick composite -comment "@$TEMP/comment.txt" build/frame_B.miff $TEMP/tmp-flag-offset.miff $TEMP/tmp-flagB.miff
magick convert $TEMP/tmp-flagB.miff -alpha off $TEMP/resultB.png

cp $TEMP/resultB.png "$DEST"'.png'
cp build/frame_B_N.png "$DEST"'_N.png'

rm -r "$TEMP"
