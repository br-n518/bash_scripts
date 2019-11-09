# Step 1: Fresh install of Ubuntu 16.04 LTS (Xenial)
sudo apt-get update
sudo apt-get upgrade

# Configure REPO_LIST and PKG_LISTS first.
# Software in folder "opt" will be auto-installed to "/opt":
# -- *.deb files are called with dpkg
# -- *.desktop files moved to ~/.local/share/applications/*
# -- *.zip files unzip to /opt/*
# -- All folders and other files moved to /opt/*

# Install everything:
sudo ./install.sh
