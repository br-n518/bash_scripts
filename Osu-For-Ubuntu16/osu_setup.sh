#!/bin/bash

echo "Install Osu! on Ubuntu 16.04"
echo

# declare var
bld_opt=



# check for command args, and that it wasn't for interactive
if [ $# -ge 1 -a "$1" != "-i" ]
then

	# check for help output request
	if [ "$1" == "-h" -o "$1" == "--help" ]
	then
		echo "$0 <command>"
		echo
		echo "Commands:"
		echo -e "mono (install mono and build Osu)\ndotnet (install .NET and build Osu)\n-h or --help (print help and exit)\n"
		echo 'Or run with no args for a short interactive prompt.'
		echo 'Multiple args not supported.'
		# exit script
		exit 0
	fi #help

	# use first arg as build option
	bld_opt="$1"

else #command args $# -ge 1

	# prompt for build option
	echo 'Would you like to use 'mono' or 'dotnet' (also: 'm' or 'd')?'
	echo
	echo -n 'Choice: '
	read bld_opt

fi #else



if [ ! -d 'osu' ]
then

	# download Osu!
	git clone https://github.com/ppy/osu
	pushd osu
	git submodule update --init --recursive
	popd

fi



# check for the build option desired
if [ "$bld_opt" == 'mono' -o "$bld_opt" == 'm' ]
then

	# Get latest nuget
	if [ ! -f 'nuget.exe' ]
	then
		wget 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe'
	fi

	# Mono dependencies
	./mono_setup.sh

	# build Osu!
	pushd osu
		mono ../nuget.exe restore
		xbuild
	popd

elif [ "$bld_opt" == "dotnet" -o "$bld_opt" == "d" ]
then

	# dotnet dependencies
	./dotnet_setup.sh
	
	OSU_DN_RUNFILE='run_osu.sh'
	
	# output run code to separate file
	echo '#!/bin/bash' > "$OSU_DN_RUNFILE"
	echo "pushd $(pwd)/osu" >> "$OSU_DN_RUNFILE"
	echo 'git pull'
	echo 'dotnet run --project osu.Desktop -c Release' >> "$OSU_DN_RUNFILE"
	echo "popd" >> "$OSU_DN_RUNFILE"
	
	# make script executable
	chmod +x "$OSU_DN_RUNFILE"
	
	# make desktop file
	echo '[Desktop Entry]' > osu_dotnet.desktop
	echo "Exec=$(pwd)/$OSU_DN_RUNFILE" >> osu_dotnet.desktop
	echo 'Name=Osu!' >> osu_dotnet.desktop
	echo 'GenericName=Osu!' >> osu_dotnet.desktop
	echo "Comment=Rhythm is just a \"click\" away." >> osu_dotnet.desktop
	echo "Icon=$(pwd)/osu/assets/lazer.png" >> osu_dotnet.desktop
	echo 'Terminal=False' >> osu_dotnet.desktop
	echo 'Type=Application' >> osu_dotnet.desktop
	echo 'Categories=Game' >> osu_dotnet.desktop
	echo >> osu_dotnet.desktop
	
	sudo cp osu_dotnet.desktop /usr/share/applications/

	./$OSU_DN_RUNFILE

fi
