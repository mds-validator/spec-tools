#!/bin/bash

source version.conf

# Exit if anything errors
set -e

if [ -z $1 ]; then
  ARG1=html
else
  ARG1=$1
fi

echo "(re)creating records/ content from spec."
rm -rf records/*

docker pull docker.sdlocal.net/validator/ddict-scripts
docker pull stratdat/sphinx:production

docker run \
  -v "$(pwd)":/mnt/workdir \
  -w /mnt/workdir\
    docker.sdlocal.net/validator/ddict-scripts ddict2rst.pl \
      -C $SPEC_TYPE \
      -V 0$SPEC_VERSION \
      -D records

docker run -v "$(pwd)":/mnt/workdir stratdat/sphinx:production make $ARG1
