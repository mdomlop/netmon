![netmon-preview](https://raw.githubusercontent.com/mdomlop/netmon/master/netmon.png "netmon running")

NetMon
======

Very simple console network traffic monitor for Linux.

Usage:

	netmon INTERFACE

Where _INTERFACE_ is one of the interfaces on `/sys/class/net/` directory.


Install
-------
You can install directly to your system. Default target directory is `/usr/local/bin/`. Change PREFIX variable to `/usr` if you want to.

### Classic mode:

	make && make install

or

	make && make install PREFIX=/usr


### Packaging:

#### pacman

Maybe you can install from [AUR](https://aur.archlinux.org/packages/netmon).
Or build the package it by hand:

	make pkg_arch

#### dpkg

To build a `.deb`:

	make pkg_debian
