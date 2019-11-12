#!/bin/bash

###########################################################################
#####   LICENSE   #########################################################
###########################################################################
# This is free and unencumbered software released into the public domain. #
#                                                                         #
# Anyone is free to copy, modify, publish, use, compile, sell, or         #
# distribute this software, either in source code form or as a compiled   #
# binary, for any purpose, commercial or non-commercial, and by any       #
# means.                                                                  #
#                                                                         #
# In jurisdictions that recognize copyright laws, the author or authors   #
# of this software dedicate any and all copyright interest in the         #
# software to the public domain. We make this dedication for the benefit  #
# of the public at large and to the detriment of our heirs and            #
# successors. We intend this dedication to be an overt act of             #
# relinquishment in perpetuity of all present and future rights to this   #
# software under copyright law.                                           #
#                                                                         #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,         #
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF      #
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  #
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR       #
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   #
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR   #
# OTHER DEALINGS IN THE SOFTWARE.                                         #
#                                                                         #
# For more information, please refer to <http://unlicense.org>            #
###########################################################################

#######################
##### INITIALIZE  #####
#######################

# Create directories, renaming any file with desired directory name.
# Directory names/paths are separated by a space.
# If directory already exists, do nothing. If REQUIRED_DIRS is
# an empty string, then don't do directory creation.
REQUIRED_DIRS="bin doc src"

# Rename suffix to use (may be empty, where a unique integer is appended).
# If a .bak file aready exists, append integer 1 before dot.
# If that file also exists, increment integer part until finding a unique filename.
# Afterwards a directory is created with the desired name, preventing reprocessing.
REQ_DIR_RENAME_FILE_SUFFIX=".bak"



# See categories DEFINITIONS and TARGETS for project-specific configuration.

#######################
#####   SYSTEM    #####
#######################
		AVAILABLE_TARGETS=
		DEFAULT_TARGET=
		declare -a TARGETS_NAME
		declare -a TARGETS_ACTION
		TARGET_COUNT=0
		#######################
		# Check for directory and create if missing.
		# If a matching file is found, rename file.
		# Usage:  assure_dirs DIR1 [DIR2 [...]]
		function assure_dirs {
			# check arg count
			if [ $# -gt 0 ]
			then
				# loop args
				for d in $@
				do
					# if something exists and is not a directory
					if [ -e "$d" -a ! -d "$d" ]
					then
						i=
						# if new filename already exists
						if [ -f "$d$REQ_DIR_RENAME_FILE_SUFFIX" ]
						then
							let i=1
							# increment pre-suffix until unique file found
							while [ -f "$d$i$REQ_DIR_RENAME_FILE_SUFFIX" ]
							do
								let i=i+1
							done
						fi
						# move file (rename)
						mv "$d" "$d$i$REQ_DIR_RENAME_FILE_SUFFIX"
						# make directory
						mkdir "$d"
					# if name doesn't exist (as file or directory)
					elif [ ! -e "$d" ]
					then
						# make directory
						mkdir "$d"
					fi
					# else: directory already exists, continue
				done
			fi
		}
		#######################
		# Create a build target to reference by name from the command line.
		# Usage:  create_target NAME COMMAND
		function create_target {
			# check arg count
			if [ $# -ge 2 ]
			then
				# add to list of targets
				AVAILABLE_TARGETS="$AVAILABLE_TARGETS $1"
				# set default target to be first target created
				if [ -z "$DEFAULT_TARGET" ]
				then
					DEFAULT_TARGET="$1"
				fi
				# put target info into arrays
				TARGETS_NAME[$TARGET_COUNT]="$1"
				TARGETS_ACTION[$TARGET_COUNT]="$2"
				# increment
				let TARGET_COUNT=TARGET_COUNT+1
			fi
		}
		#######################
		# Run defined targets
		# Usage:  run_targets TARGET1 [TARGET2 [...]]
		function run_targets {
			if [ $# -ge 1 ]
			then
				# loop args
				for targ in $@
				do
					# loop for matching target
					tidx=0
					for t in $AVAILABLE_TARGETS
					do
						# if match
						if [ "$t" == "$targ" ]
						then
							TARG_COMMAND="${TARGETS_ACTION[$tidx]}"
							# output target name
							if [ ${#TARG_COMMAND} -ge 11 -a "${TARG_COMMAND:0:11}" == "run_targets" ]
							then
								echo "BEGIN \"$t\": ${TARG_COMMAND:11}"
							else
								echo "BEGIN TARGET: \"$t\""
							fi
							# run command
							$TARG_COMMAND
							# break for next function arg
							break
						fi
						# increment
						let tidx=tidx+1
					done
				done
			fi
		}
#######################
##### END  SYSTEM #####
#######################



#######################
# Create required directories.
if [ ! -z "$REQUIRED_DIRS" ]
then
	assure_dirs $REQUIRED_DIRS
fi




#######################
##### DEFINITIONS #####
#######################
# Declare your variables here.

CC="gcc"

CFLAGS="-std=c99 -Wall"
LDFLAGS="-lm -lGL -lGLU"
#-lGLEW

SRC="src/*.c src/third_party/*.c"
OUTPUT="bin/kernel"

#######################
#####   TARGETS   #####
#######################
# Declare your build targets here.

create_target build "run_targets compile link"
create_target compile "$CC -c $CFLAGS $SRC"
create_target link "$CC -o $OUTPUT *.o $LDFLAGS"
create_target clean "rm -f *.o"
create_target all "run_targets clean build"



#######################
#####  CLI  ARGS  #####
#######################

if [ $# -gt 0 ]
then
	if [ "$1" == "help" -o "$1" == "--help" -o "$1" == "-h" ]
	then
		# help header
		echo -e "\nBASH Build Script\n\nUsage:\n  $0 [target]\n\n  Default target for no args given: \"$DEFAULT_TARGET\"\n\nTargets:"
		# print available targets
		for t in $AVAILABLE_TARGETS
		do
			echo -e "  * $t"
		done
		echo
		exit 0
		
	fi
	# assign target
	TARGET="$1"
else
	TARGET="$DEFAULT_TARGET"
fi

#######################
#####     RUN     #####
#######################

echo "BUILD: $0 $TARGET"
run_targets $TARGET
echo "DONE"

