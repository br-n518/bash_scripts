#!/bin/bash
# NOTE: run with sudo

### PATHS
LOCAL_SOFTWARE_FOLDER=opt
LOCAL_SOFTWARE_OUTPUT_FOLDER=/opt
APP_DIR=~/.local/share/applications
#APP_DIR=/usr/share/applications

### Dungeon Crawl Stone Soup
if [ ! -f ".crawl_repo_done" ]; then
echo 'deb https://crawl.develz.org/debian crawl 0.21' | tee -a /etc/apt/sources.list
wget https://crawl.develz.org/debian/pubkey -O - | apt-key add -
touch ".crawl_repo_done"
fi



### ADD REPOSITORIES
./repositories.sh REPO_LIST
apt-get update

### INSTALL PACKAGES
./packages.sh PKG_LISTS/*


apt-get install -y p7zip-full

### INSTALL LOCAL SOFTWARE
if [ ! -d "$LOCAL_SOFTWARE_FOLDER" ]; then exit 0; fi
# CHANGE DIRECTORY (cd)
cd "$LOCAL_SOFTWARE_FOLDER"
# copy files to software output folder
for app in *; do
	# check if the file contains .deb in the name
	ext=${app: -4}
	if [ "$ext" == ".deb" ]; then #skip for now
		continue
	elif [ "$ext" == ".zip" ]; then #unzip to output folder
		unzip -ud "$LOCAL_SOFTWARE_OUTPUT_FOLDER" "$app"
	#elif [ "${app: -3}" == ".7z" ]; then
	#	7za x "$app" -o"$LOCAL_SOFTWARE_OUTPUT_FOLDER"
	elif [ "${app: -8}" == ".desktop" ]; then
	    cp -u "$app" "$APP_DIR"
	else #copy other files, and directories, to output folder
		cp -ur "$app" "$LOCAL_SOFTWARE_OUTPUT_FOLDER/$app"
	fi
done

# install *.deb
if [ ! -z "*.deb" ]; then
	dpkg -i *.deb
fi
