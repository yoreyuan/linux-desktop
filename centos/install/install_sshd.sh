#!/usr/bin/env bash
set -e

echo 123456 | passwd root --stdin

yum install -y openssh-server
systemctl enable sshd
