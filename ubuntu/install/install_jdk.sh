#!/usr/bin/env bash
set -e

echo "Install Zulu jdk"
curl -s https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg
echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | tee /etc/apt/sources.list.d/zulu.list
echo "Package: zulu17-*\nPin: version 17.0.8-*\nPin-Priority: 1001" > /etc/apt/preferences
apt -qq update

# zulu17-jdk=17.0.8-*
apt install -y zulu17-jdk
apt -qq -y purge --auto-remove software-properties-common
