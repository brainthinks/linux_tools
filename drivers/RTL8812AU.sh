#!/usr/bin/env bash

git clone https://github.com/abperiasamy/rtl8812AU_8821AU_linux.git
cd rtl8812AU_8821AU_linux
sudo make -f Makefile.dkms install

echo "The ${MODEL} driver has been installed.  Reboot for the hardware to be available."
