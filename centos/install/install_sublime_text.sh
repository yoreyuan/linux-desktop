#!/usr/bin/env bash
set -ex

ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/amd64/g')
if [ "$ARCH" == "arm64" ] ; then
  echo "Chrome not supported on arm64, skipping Chrome installation"
  exit 0
fi

# XFCE时安装Sublime Text
isInstall=$INSTALL_SUBLIME_TEST
if [ "Xfce" == "$DESKTOP_TYPE" ]; then
  if [ -z "$isInstall" ]; then
    isInstall="true"
  fi
else
  if [ -z "$isInstall" ]; then
    isInstall="false"
  fi
fi

if [ "true" = "$isInstall" ]; then
  echo "Install Sublime Text"
  rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

  yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
  yum install -y sublime-text

  cp /usr/share/applications/sublime_text.desktop $HOME/Desktop/
  chmod +x $HOME/Desktop/sublime_text.desktop
  chown 1000:1000 $HOME/Desktop/sublime_text.desktop
fi
