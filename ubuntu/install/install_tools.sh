#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=$DEBIAN_FRONTEND
echo "====== DEBIAN_FRONTEND=$DEBIAN_FRONTEND"

#echo "alias ll='ls -l'  2>/dev/null" >> /etc/profile.d/colorgrep.sh

echo "Install some common tools for further installation"

apt-get install -y bzip2 wmctrl mesa-utils bc

#update mesa to latest
#add-apt-repository ppa:kisak/turtle
#apt-get update
#apt full-upgrade -y

apt-get -y --fix-missing --no-install-recommends install \
  apache2 \
  bridge-utils \
  ca-certificates \
  dnsutils \
  curl \
  dos2unix \
  gnupg \
  inetutils-ping \
  jq \
  less \
  locales \
  lrzsz \
  lsof \
  mtr \
  mysql-client \
  nano \
  net-tools \
  procps \
  sudo \
  tcpdump \
  telnet \
  traceroute \
  tree \
  tini \
  vim \
  wget \
  zip unzip

### docker
if [ "true" = "$INSTALL_DOCKER" ]; then
  curl -fsSL https://get.docker.com -o get-docker.sh
  mv get-docker.sh $INST_SCRIPTS/get-docker.sh
  sh $INST_SCRIPTS/get-docker.sh
  systemctl enable docker
fi

