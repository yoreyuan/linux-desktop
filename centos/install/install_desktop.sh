#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=$DEBIAN_FRONTEND
echo "====== DEBIAN_FRONTEND=$DEBIAN_FRONTEND"

#echo "alias ll='ls -l'  2>/dev/null" >> /etc/profile.d/colorgrep.sh

ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#alternatives --set python /usr/bin/python3
#ln -sf /usr/bin/python3 /usr/bin/python

yum install -y deltarpm

# 中文
#locale -a | grep CN
yum install -y kde-l10n-Chinese
yum reinstall -y glibc-common
#localedef -c -f GB18030 -i zh_CN zh_CN.GB18030
#echo 'LANG="zh_CN.GB18030"' > /etc/locale.conf
localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
echo "LANG=zh_CN.UTF-8" > /etc/locale.conf && source /etc/locale.conf

# fount
yum-config-manager --enable ol7_optional_latest
yum install -y \
  google-noto-emoji-fonts \
  google-noto-sans-cjk-fonts \
  google-noto-sans-fonts


replace_default_xinit() {
  mkdir -p /etc/X11/xinit
  cat >/etc/X11/xinit/xinitrc <<EOL
#!/bin/sh
for file in /etc/X11/xinit/xinitrc.d/* ; do
        . \$file
done
. /etc/X11/Xsession
EOL
  chmod +x /etc/X11/xinit/xinitrc
}

replace_default_99x11_common_start() {
  if [ -f /etc/X11/Xsession.d/99x11-common_start ] ; then
    cat >/etc/X11/Xsession.d/99x11-common_start <<EOL
# This file is sourced by Xsession(5), not executed.
# exec $STARTUP
EOL
  fi
}


#################################
# install RDP
#yum -y install epel-release
yum -y install xrdp tigervnc-server

#默认端口为3389，配置文件为：/etc/xrdp/xrdp.ini

if [ "Xfce" == "$DESKTOP_TYPE" ]; then
  echo "xfce4-session" > $HOME/.Xclients
  chmod +x $HOME/.Xclients
  sed -i "s/ssl_protocols=/; ssl_protocols=/g" /etc/xrdp/xrdp.ini
  #sed -i "58i ssl_protocols=TLSv1, TLSv1.3, TLSv1.1, TLSv1.2, TLSv3" /etc/xrdp/xrdp.ini
  sed -i "59i ssl_protocols=TLSv1, TLSv1.1, TLSv1.2" /etc/xrdp/xrdp.ini
fi

systemctl enable xrdp


##################################
# 登录时桌面选择
#yum install lightdm
#systemctl enable lightdm

if [ "GNOME" == "$DESKTOP_TYPE" ]; then
  #yum grouplist
  #CentOS提供了几种桌面环境，例如GNOME、KDE、Xfce等
  # 这里按照使用比较广泛的 GNOME
  yum -y groupinstall "GNOME Desktop"
  #默認進入桌面
  systemctl set-default graphical.target
  # 默認進入命令行
  #systemctl set-default multi-user.target
  # 查看當前啟動模式
  #systemctl get-default
fi

###### KDE桌面
if [ "KDE" == "$DESKTOP_TYPE" ]; then
  yum -y groupinstall "KDE Plasma Workspaces"
  systemctl set-default graphical.target
fi

###### XFCE 4
if [ "Xfce" == "$DESKTOP_TYPE" ]; then
  echo "Install Xfce4 UI components"

  # 安装 x server
  #yum -y groupinstall "X Window system"
  #systemctl isolate graphical.target

  yum-config-manager --setopt=epel.exclude=nss_wrapper --save
  yum -y groupinstall "Xfce"
  yum install -y \
      gvfs \
      wmctrl \
      xclip \
      xfce4-notifyd \
      xset

  systemctl set-default graphical.target

  replace_default_xinit
  if [ "${START_XFCE4}" == "1" ] ; then
    replace_default_99x11_common_start
  fi

  # Override default login script so users cant log themselves out of the desktop dession
  cat >/usr/bin/xfce4-session-logout <<EOL
#!/usr/bin/env bash
notify-send "Logout" "Please logout or destroy this desktop using the Kasm Control Panel" -i /usr/share/icons/ubuntu-mono-dark/actions/22/system-shutdown-panel-restart.svg
EOL

  # Add a script for launching Thunar with libnss wrapper.
  # This is called by ~.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
  cat >/usr/bin/execThunar.sh <<EOL
#!/bin/sh
. $STARTUPDIR/generate_container_user
/usr/bin/Thunar --daemon
EOL
  chmod +x /usr/bin/execThunar.sh

  cat >/usr/bin/desktop_ready <<EOL
#!/usr/bin/env bash
until pids=\$(pidof xfce4-session); do sleep .5; done
EOL
  chmod +x /usr/bin/desktop_ready

  # Change the default behavior of the delete key which is to move to trash. This will now prompt the user to permanently
  # delete the file instead of moving it to trash
  mkdir -p /etc/xdg/Thunar/
  cat >>/etc/xdg/Thunar/accels.scm<<EOL
(gtk_accel_path "<Actions>/ThunarStandardView/delete" "Delete")
(gtk_accel_path "<Actions>/ThunarLauncher/delete" "Delete")
(gtk_accel_path "<Actions>/ThunarLauncher/trash-delete-2" "")
(gtk_accel_path "<Actions>/ThunarLauncher/trash-delete" "")
EOL

  # Support desktop icon trust
  cat >>/etc/xdg/autostart/desktop-icons.desktop<<EOL
[Desktop Entry]
Type=Application
Name=Desktop Icon Trust
Exec=/dockerstartup/trustdesktop.sh
EOL
  chmod +x /etc/xdg/autostart/desktop-icons.desktop

fi
