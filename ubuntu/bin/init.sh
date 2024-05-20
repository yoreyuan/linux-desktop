#!/usr/bin/env bash

set -xeuo pipefail

#mkdir -p /var/run/sshd
#systemctl start ssh
#service ssh start
#/usr/sbin/sshd -D
#/etc/init.d/ssh start

#apt-get -qq update
#apt-get install -qq -y xrdp
#apt-get install -qq -y ubuntu-desktop
# apt-get install -y dbus
#rm -rf /var/lib/apt/lists/*
#service dbus status
#service xrdp start
#systemctl start xrdp
# gnome-session

adduser yore
usermod -aG sudo yore
echo yore:ydd | chpasswd
echo 'yore ALL=(ALL) NOPASSWD:ALL' | tee -a /etc/sudoers > /dev/null

if [ ! -e "/root/.m2" ]; then
  mkdir /root/.m2
  #ln -s /home/yore/.m2 /root/.m2
fi

if [ ! -e "/root/.m2/repository" ]; then
  ln -s /opt/repository /root/.m2/repository
fi

echo "success!"

#sleep inf
