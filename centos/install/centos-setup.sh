#!/usr/bin/env bash
set -ex

if [ "GNOME" == "$DESKTOP_TYPE" ] ||  [ "KDE" == "$DESKTOP_TYPE" ] ; then

  systemctl disable firewalld.service
fi

# disable selinux
if [ "Xfce" != "$DESKTOP_TYPE"  ]; then
  sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
fi

# config DNS
#echo "$(sed 's/nameserver .*/nameserver 8.8.8.8/' /etc/resolv.conf)" > /etc/resolv.conf
#chmod 777 /etc/resolv.conf
#cat >> /etc/resolv.conf <<EOF
#nameserver 8.8.8.8
#options ndots:0
#EOF
#chmod 644 /etc/resolv.conf
