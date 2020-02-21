#!/bin/bash

if [ ! -d 'osu' ]
then

	# download Osu!
	git clone https://github.com/ppy/osu
	pushd osu
	git submodule update --init --recursive
	popd

fi


pushd osu

git pull
dotnet publish osu.Desktop -r linux-x64 -c Release

popd



