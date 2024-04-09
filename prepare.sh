#!/bin/bash
set -e
set -x

mkdir -p build/png
rm -f build/*.miff build/*.png

magick convert assets/fabric.png build/fabric.miff
magick convert -size 512x256 xc:none build/blank.miff

magick convert 'assets/(BlackfootStudios)UnitedStates_B.png' assets/frame-mask.png -alpha off -compose copy_opacity -composite build/frame_B.miff
magick convert 'assets/(BlackfootStudios)UnitedStates_B_N.png' assets/frame-mask.png -alpha off -compose copy_opacity -composite build/BN.miff
magick composite -comment @assets/SOURCE_TAIL.txt build/BN.miff assets/fabric_N.png build/frame_B_N.png

for f in build/*.png
do
	./optimize.sh "$f"	
done

