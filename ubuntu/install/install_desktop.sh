#!/usr/bin/env bash
set -e

#apt-get upgrade
# Update tzdata noninteractive (otherwise our script is hung on user input later).
DEBIAN_FRONTEND=noninteractive TZ=$TZ apt-get -y install tzdata
apt-get install -y --fix-missing \
  language-pack-zh-hans \
  language-pack-zh-hans-base \
  python3 \
  software-properties-common

#echo "generate locales for en_US.UTF-8"
#locale-gen en_US.UTF-8
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen zh_CN.UTF-8
echo "export LANG=zh_CN.UTF-8" >> $HOME/.bashrc

update-alternatives --install /usr/bin/python python /usr/bin/python3 1
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


#默认端口为3389，配置文件为：/etc/xrdp/xrdp.ini

#if [ "Xfce" == "$DESKTOP_TYPE" ]; then
#  echo "xfce4-session" > $HOME/.Xclients
#  chmod +x $HOME/.Xclients
#  sed -i "s/ssl_protocols=/; ssl_protocols=/g" /etc/xrdp/xrdp.ini
#  #sed -i "58i ssl_protocols=TLSv1, TLSv1.3, TLSv1.1, TLSv1.2, TLSv3" /etc/xrdp/xrdp.ini
#  sed -i "59i ssl_protocols=TLSv1, TLSv1.1, TLSv1.2" /etc/xrdp/xrdp.ini
#fi


##################################

### GNOME桌面
if [ "GNOME" = "$DESKTOP_TYPE" ]; then
  echo "请手动执行下面的命令安装 GNOME"
  #apt update
  apt upgrade -y
  #apt install -y ubuntu-desktop
fi


### Install xfce UI
if [ "Xfce" = "$DESKTOP_TYPE" ]; then
  bash $INST_SCRIPTS/install_xfce_ui.sh
  mv $INST_SCRIPTS/xfce/.config $HOME/

  mkdir -p /usr/share/extra/backgrounds/
  mkdir -p /usr/share/extra/icons/

  mv /dockerstartup/images/bg_default.png /usr/share/extra/backgrounds/bg_default.png
  cp /dockerstartup/images/icon_ubuntu.png /usr/share/extra/icons/icon_ubuntu.png
  mv /dockerstartup/images/icon_ubuntu.png /usr/share/extra/icons/icon_default.png

  apt-get update
  apt-get install -y xdotool
  apt-get install -y vlc git tmux

fi


### Install Deepin Desktop
if [ "Deepin" = "$DESKTOP_TYPE" ]; then
  # 确保所有系统包都是最新的
  apt install -y wget apt-transport-https gnupg2 software-properties-common
  add-apt-repository ppa:ubuntudde-dev/stable
  apt update -y
  apt install -y ubuntudde-dde dde-file-manager
  #apt install -y deepin-gtk-theme
  dpkg-reconfigure lightdm
fi

### Install LXDE
if [ "LXQt" = "$DESKTOP_TYPE" ]; then
  apt-get install -y lubuntu-desktop
fi

##################################
# install RDP
#tightvncserver
apt-get install -y xrdp
