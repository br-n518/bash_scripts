
# Osu! install scripts for Ubuntu 16.04

There are two options:

- .NET install (`dotnet`)
- Mono install (`mono`)

.NET builds and runs. The Mono setup doesn't build for me.

The script `mono_setup.sh` is still useful for downloading the latest Mono.

**WARNING**: Make sure you copy these scripts to where you want osu to actually be.
The generated `desktop` file's paths are built using `pwd` (print working directory).

Then delete the following:

- osu_setup.sh
- dotnet_setup.sh
  - .dotnet_setup_lock
- mono_setup.sh
  - .mono_setup_lock

You will have the following new files:

- `osu_dotnet.desktop`
  - Copied to `/usr/share/applications`.
- `run_osu.sh`
  - Desktop file points here.
  - Will update with `git pull` and rebuild as needed.
- Keep your cloned **osu** folder without moving it.

## Usage

Use `osu_setup.sh` to install Osu! (and dependencies).

Note that the .NET version compiles Osu! for `Release` instead of `Debug`.

If .NET won't download and install due to "unexpected size", wait 30 minutes, they're updating packages.



## Usage example

***

	# copy scripts to /opt (or folder of your choice)
	# if in your home folder, you won't need 'sudo'
	cp *.sh ~/osu_game
	cd ~/osu_game
	
	# make sure scripts are all executable
	chmod +x ./*.sh
	
	# build Osu!
    ./osu_setup.sh dotnet

    # remove setup files
	rm *_setup.sh .*_setup_lock
	
***

Run the `mono_setup.sh` file anywhere, it just installs latest mono.
You will need root priviledges for apt-get.
