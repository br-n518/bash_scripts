#!/bin/bash
# For Ubuntu 16.04

# Mono latest install

if [ ! -f ".mono_setup_lock" ]
then 
echo > .mono_setup_lock

# get security keys
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
sudo apt-get install apt-transport-https ca-certificates

# REPO for Mono latest
echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

# REPO for MonoDevelop (optional)
#echo "deb https://download.mono-project.com/repo/ubuntu vs-xenial main" | sudo tee /etc/apt/sources.list.d/mono-official-vs.list

sudo apt-get update

# compiler and xbuild
sudo apt-get install mono-devel mono-xbuild ca-certificates-mono

# full system (optional, recommended)
#sudo apt-get install mono-complete

# ASP.NET (optional)
#sudo apt-get install mono-xsp4

# IDE (optional)
#sudo apt-get install monodevelop

fi
