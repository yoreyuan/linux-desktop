FROM centos:centos7.9.2009 AS buildGit

MAINTAINER YoreYuen

ENV INST_SCRIPTS=/tmp/install
ADD ./install $INST_SCRIPTS
WORKDIR $INST_SCRIPTS

# 华为镜像源
RUN set -xeu && \
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak && \
    #wget -O /etc/yum.repos.d/CentOS-Base.repo https://repo.huaweicloud.com/repository/conf/CentOS-7-reg.repo && \
    mv $INST_SCRIPTS/CentOS-7-reg.repo /etc/yum.repos.d/CentOS-Base.repo && \
    chmod 644  /etc/yum.repos.d/CentOS-Base.repo && \
    yum clean all && yum repolist

RUN bash $INST_SCRIPTS/build_git.sh


#FROM centos:latest
FROM centos:centos7.9.2009

ENV HOME=/root
ENV INST_SCRIPTS=/tmp/install
#ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ENV LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh' LC_ALL='zh_CN.utf8'
ENV TZ=Asia/Shanghai
ENV JAVA_HOME=/usr/lib/jvm/zulu17

ARG DEBIAN_FRONTEND=noninteractive
ARG START_XFCE4=1
ARG INSTALL_CHROME="true"
ARG INSTALL_DOCKER=false
ARG INSTALL_IDEA="true"
ARG INSTALL_MAVEN="true"
ARG INSTALL_SUBLIME_TEST=""
ARG DESKTOP_TYPE=GNOME
#ARG DESKTOP_TYPE=KDE
#ARG DESKTOP_TYPE=Xfce

ADD ./install $INST_SCRIPTS

WORKDIR $HOME
RUN mkdir -p $HOME/Desktop

# 清华镜像源
RUN set -xeu && \
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-*.repo && \
    yum install -y epel-release && \
    yum clean all && yum -y -q update && yum makecache

### Ensure all needed packages are installed.
### Consider "yum install -y gettext nss_wraper". There's a typo in nss_wraper
### (should be nss_wrapper), and yum would just ignore it. Thus, a necessary
### package would be missing. With skip_missing_names_on_install, yum will exit
### with 1 exit code and that will stop image building.
RUN yum-config-manager --setopt=skip_missing_names_on_install=False --save

### Install Desktop
RUN DEBIAN_FRONTEND=$DEBIAN_FRONTEND bash $INST_SCRIPTS/install_desktop.sh

### Install openssh server
RUN bash $INST_SCRIPTS/install_sshd.sh

### Install common tools
RUN  bash $INST_SCRIPTS/install_tools.sh

### Install JDK
RUN bash $INST_SCRIPTS/install_jdk.sh

### Install Chrome
RUN bash $INST_SCRIPTS/install_chrome.sh

### Install IDEA
RUN bash $INST_SCRIPTS/install_idea.sh

### Sublime Text
RUN bash $INST_SCRIPTS/install_sublime_text.sh

## Cleanup job
RUN bash $INST_SCRIPTS/centos-setup.sh
RUN bash $INST_SCRIPTS/centos-cleanup.sh && rm -rf $INST_SCRIPTS


### Upgrade git
COPY --from=buildGit /opt/rh /opt/rh
COPY --from=buildGit /usr/local/git /usr/local/git
RUN set -xeu && \
    ln -sf /opt/rh/devtoolset-9/root/bin/gcc /usr/bin/gcc && \
    ln -sf /opt/rh/devtoolset-9/root/bin/g++ /usr/bin/g++ && \
    ln -sf /opt/rh/devtoolset-9/root/bin/sudo /usr/bin/sudo && \
    ln -sf /usr/local/git/bin/git /usr/bin/git


EXPOSE 22
EXPOSE 3389
ENTRYPOINT ["/usr/sbin/init"]
