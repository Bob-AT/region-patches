#
# This file is sourced by `process-patch.sh`
#
W=472
H=236
SIZE="$W"x"$H"

project_onto_self() { # center flag $1 on a stretched version of itself
  magick composite -gravity center \( "$1" -resize x$H \) \( "$1" -resize "$SIZE"! \) "$2"
}

project_onto_color() { # center flag $1 on color $2
  magick composite -gravity center \( "$1" -resize x$H \) \( -size $SIZE "$2" \) "$3"
}

project_left() { # place flag $2 with offset $1 on a stretched version of itself
  magick composite -geometry $1 \( $2 -resize x$H \)  \( $2 -resize "$SIZE"! \) "$3"
}

#
# Transformation functions for flags. 
# "$1" is the ouput `.png` file.
#

transform_AF() {
  project_onto_self ./region-flags/png/AF.png "$1"
}

transform_blank() {
  magick -size $SIZE xc:none "$1"
}

transform_CA_PE() { # center flag on white background
  H=$(( $H - 8 ))
  project_onto_color ./region-flags/png/CA-PE.png xc:white "$1"
}

transform_CH_A () { # center quadratic CH flag on transparent background
  project_onto_color ./region-flags/png/CH.png xc:none "$1"
}

transform_CH_B () { # center quadratic CH flag on red background
  project_onto_color ./region-flags/png/CH.png xc:red "$1"
}

transform_DE_BB () {
  project_onto_self ./region-flags/png/DE-BB.png "$1" 
}

transform_DE_BE () {
  project_onto_self ./region-flags/png/DE-BE.png "$1" 
}

transform_DE_HH () { 
  project_onto_self ./region-flags/png/DE-HH.png "$1" 
}

transform_DE_NI () { 
  project_onto_self ./region-flags/png/DE-NI.png "$1" 
}

transform_DE_SL () { 
  project_onto_self ./region-flags/png/DE-SL.png "$1" 
}

transform_DE_ST () { 
  project_onto_self ./region-flags/png/DE-ST.png "$1" 
}

transform_DE_RP () { # Project DE-RP on DE flag with 10px offset
  magick composite -geometry +10+0 \( ./region-flags/png/DE-RP.png -resize x$H \)  \( ./region-flags/png/DE.png -resize "$SIZE"! \) "$1"
}

transform_IL_A() { # center IL flag on transparent background
  project_onto_color ./region-flags/png/IL.png xc:none "$1"
}

transform_IL_B() {
  project_onto_self ./region-flags/png/IL.png "$1"
}

transform_KR() {
  project_onto_color ./region-flags/png/KR.png xc:white "$1"
}

transform_NATO_A() {
  echo "https://en.wikipedia.org/wiki/File:Flag_of_NATO.svg; " > $TEMP/comment.tmp
  project_onto_color ./extra-flags/NATO.png xc:none "$1"
}

transform_NATO_B() {
  echo "https://en.wikipedia.org/wiki/File:Flag_of_NATO.svg; " > $TEMP/comment.tmp
  project_onto_color ./extra-flags/NATO.png 'xc:#004990' "$1"
}

transform_NP() { # resize NP flag and place it with 4px x/y offset
 H=$(( $H - 8 ))
 magick composite -geometry +4+4 \( ./region-flags/png/NP.png -resize x$H \) \( -size $SIZE xc:none \) "$1"
}

transform_PK() {
  project_onto_self ./region-flags/png/PK.png "$1"
}

transform_RS() {
  project_left +0+0 ./region-flags/png/RS.png "$1"
}

transform_SI() {
  project_left +0+0 ./region-flags/png/SI.png "$1"
}

transform_SK() {
  project_left +0+0 ./region-flags/png/SK.png "$1"
}

transform_US_REV () { # reverse US flag
  magick convert ./region-flags/png/US.png -flop -resize "$SIZE"! "$1"
}

transform_US_RI() {
  project_onto_color ./region-flags/png/US-RI.png xc:white "$1"
}

transform_US_TX() {
  project_left +8+0 ./region-flags/png/US-TX.png "$1"
}

transform_white() {
  magick -size $SIZE xc:white "$1"
}
