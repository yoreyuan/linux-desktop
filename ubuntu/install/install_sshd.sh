#!/usr/bin/env bash
set -e

apt-get install -y openssh-server

sed -i 's/#PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

#取消pam限制
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

echo root:123456 | chpasswd
