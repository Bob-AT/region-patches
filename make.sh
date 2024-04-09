#!/bin/bash
set -e
CORES=6
LIST=LIST.txt
test -z "$1" || LIST="$1"
test -d region-flags || git clone https://github.com/fonttools/region-flags.git
test -f build/fabric.miff || bash ./prepare.sh
mkdir -p build/png
rm -rf build/*.7z build/GroundBranch build/png-opt

LIMIT=10000
test -n "$1" && LIMIT=$1

cat "$LIST" | sed -e '/^#/d' -e '/^ [ ]*$/d' | xargs -P$CORES -t -n3 bash ./process-patch.sh -q

cp -r build/png build/png-opt
if [[ "$RELEASE" -eq 1 ]]
then
	find build/png-opt -type f | grep -vF '_N.png' | xargs -P$CORES -n1 ./optimize.sh   
fi

mkdir -p build/GroundBranch/Content/GroundBranch/Patches/Region/
cp build/png-opt/*.png  build/GroundBranch/Content/GroundBranch/Patches/Region/
cd build
7z a RegionPatches-`date --iso`.7z GroundBranch
