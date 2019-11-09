#!/bin/bash
### INSTALL REPOSITORY SOFTWARE
# No need to edit this file. Edit software.sh instead.
# This file accepts a filename (or filenames) for file with lists of packages.
# Those packages in the file (separated by newline or by space) are installed.
### Run this file with sudo
targets=
for f in $@; do if [ -f "$f" ]; then
for s in $(cat "$f"); do if [ "${s: 0:1}" != "#" ]; then
targets="$targets $s"
fi;done
fi;done
apt-get -y install $targets
