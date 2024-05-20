#!/usr/bin/env bash
set -e


### gcc
ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/amd64/g')
if [ "amd64" = "$ARCH" ]; then
  #yum -y install gcc gcc-c++ kernel-devel
  yum install -y https://repo.huaweicloud.com/centos/7.9.2009/extras/x86_64/Packages/centos-release-scl-rh-2-3.el7.centos.noarch.rpm
  yum install -y https://repo.huaweicloud.com/centos/7.9.2009/extras/x86_64/Packages/centos-release-scl-2-3.el7.centos.noarch.rpm
  yum install -y devtoolset-9-gcc-c++ make
  #scl enable devtoolset-9 bash
  source /opt/rh/devtoolset-9/enable
  # version 9.3.1
  ln -sf /opt/rh/devtoolset-9/root/bin/gcc /usr/bin/gcc
  ln -sf /opt/rh/devtoolset-9/root/bin/g++ /usr/bin/g++
else
  exit 0
fi


### git
yum install -y zlib zlib-devel
yum install -y perl-devel perl-CPAN
yum install -y tcl-devel gettext-devel
# 默认带的git版本是1.8.3.1有点老，这里现在最新版编译
gitVersion="2.42.0"
if [ ! -e "$INST_SCRIPTS/git.tar" ]; then
  #https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.42.0.tar.xz
  wget -O git.tar  https://mirrors.edge.kernel.org/pub/software/scm/git/git-$gitVersion.tar.gz
  mv git.tar  $INST_SCRIPTS/
fi
mkdir $INST_SCRIPTS/git
tar -zxf $INST_SCRIPTS/git.tar --strip-components=1 -C $INST_SCRIPTS/git/
cd $INST_SCRIPTS/git/
./configure --prefix=/usr/local/git
make && make install
ln -sf /usr/local/git/bin/git /usr/bin/git
