#!/bin/bash
### ADD REPOSITORIES
# No need to edit this file. Edit repo_list instead.
# This file accepts a filename (or filenames) for file with lists of PPA links.
# Those PPAs in the file (separated by newline or by space) are added.
### Run this file with sudo
for f in $@; do if [ -f "$f" ]; then
for s in $(cat "$f"); do if [ "${s: 0:1}" != "#" ]; then
add-apt-repository -y $s
fi;done
fi;done
