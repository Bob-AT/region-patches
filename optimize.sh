#!/bin/bash

if [[ "$RELEASE" -eq 1 ]]
then
  optipng -o7 "$1"
  advdef -z4 "$1"
fi

