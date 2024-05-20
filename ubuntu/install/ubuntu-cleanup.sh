#!/usr/bin/env bash
set -e

# Distro package cleanup
apt-get autoremove -y
apt-get autoclean -y

systemctl disable apache2

rm -rf /var/lib/apt/lists/* /var/tmp/*
rm -rf /dockerstartup/images


# Remove xfce4-screensaver bin if it exists
if which xfce4-screensaver; then
  rm -f $(which xfce4-screensaver)
fi
