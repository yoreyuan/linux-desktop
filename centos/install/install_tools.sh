#!/usr/bin/env bash
set -e

echo "Install some common tools for further installation"

yum install -y curl less tree vim wget which
yum install -y bc
#bind软件提供的一组DNS工具包，里面有一些DNS相关的工具。主要：dig，host，nslookup，nsupdate
yum install -y bind-utils
yum install -y bridge-utils
yum install -y bzip2
yum install -y ca-certificates
yum install -y diffutils
#将Windows格式文件转换为Unix、Linux格式的实用命令。例如将文件中的\r\n 转换为\n
yum install -y dos2unix
yum install -y epel-release
yum install -y file
#包括：find、locate、which、xargs等
yum install -y findutils
yum install -y httpd
yum install -y iotop
yum install -y jq
yum install -y lrzsz
yum install -y lsof
yum install -y make
yum install -y mysql
#网络测试工具
yum install -y mtr
yum install -y nano
#提供netstat命令
yum install -y net-tools
yum install -y python3 python3-devel
#yum install -y tar
yum install -y tcpdump
yum install -y telnet
#超轻量级的 init 进程管理器， Docker 1.13 或更高版本Tini 已包含在 Docker 中，如果要启用 Tini，只需将 --init 参数传递给 Docker run 即可。
#yum install -y tini
#可以利用ICMP协议定位用户的计算机和目标计算机之间的所有路由器
yum install -y traceroute
#类似”按键精灵“的工具
yum install -y xdotool
yum install -y zip unzip


### docker
if [ "true" = "$INSTALL_DOCKER" ]; then
  #https://docs.docker.com/engine/install/centos/#install-using-the-repository
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  yum install -y docker-ce \
                 docker-ce-cli \
                 containerd.io \
                 docker-buildx-plugin \
                 docker-compose-plugin

  systemctl enable docker
fi

