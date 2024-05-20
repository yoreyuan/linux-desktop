FROM ubuntu:latest

MAINTAINER YoreYuen

ENV LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh' LC_ALL='zh_CN.utf8'
ENV TZ=Asia/Shanghai
ENV JAVA_HOME=/usr/lib/jvm/zulu17
ENV NOTVISIBLE "in users profile"
ENV INST_SCRIPTS=/tmp/install
ENV HOME=/root
ENV DISTRO=ubuntu
ENV MIRROR_HOST="http://repo.huaweicloud.com"
#ENV MIRROR_HOST="http://mirrors.aliyun.com"

ARG DEBIAN_FRONTEND=noninteractive
ARG INSTALL_CHROME="true"
ARG INSTALL_CHROMIUM="false"
ARG INSTALL_DOCKER=false
ARG INSTALL_FIREFOX="false"
ARG INSTALL_IDEA="true"
ARG INSTALL_MAVEN="true"
ARG INSTALL_SUBLIME_TEXT=""
ARG INSTALL_VS_CODE="false"
ARG DESKTOP_TYPE=GNOME
#ARG DESKTOP_TYPE=Xfce

### Home setup
WORKDIR $HOME
RUN mkdir -p $HOME/Desktop

ADD ./common /dockerstartup
ADD ./xfce $INST_SCRIPTS/xfce
ADD ./install $INST_SCRIPTS


### 华为镜像源
RUN set -xeu && \
    echo 'Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::http::Timeout "60";' > /etc/apt/apt.conf.d/80-timeouts && \
    sed -i "s@http://.*archive.ubuntu.com@${MIRROR_HOST}@g" /etc/apt/sources.list && \
    sed -i "s@http://.*security.ubuntu.com@${MIRROR_HOST}@g" /etc/apt/sources.list && \
    apt-get -qq update


### Install common tools
RUN DEBIAN_FRONTEND=$DEBIAN_FRONTEND bash $INST_SCRIPTS/install_tools.sh

### Install Desktop
RUN DEBIAN_FRONTEND=$DEBIAN_FRONTEND bash $INST_SCRIPTS/install_desktop.sh

### Install openssh server
RUN bash $INST_SCRIPTS/install_sshd.sh

### Install custom fonts
RUN bash $INST_SCRIPTS/install_custom_fonts.sh

### Install JDK
RUN bash $INST_SCRIPTS/install_jdk.sh

### Custom Folder Emblems
RUN bash $INST_SCRIPTS/install_emblems.sh

### Install Chrome
RUN bash $INST_SCRIPTS/install_chrome.sh

### Install Chromium
RUN bash $INST_SCRIPTS/install_chromium.sh

### Install Firefox
RUN bash $INST_SCRIPTS/install_firefox.sh

### Install Sublime Text
RUN bash $INST_SCRIPTS/install_sublime_text.sh

### Install IDEA
RUN bash $INST_SCRIPTS/install_idea.sh

### Install VS Code
RUN bash $INST_SCRIPTS/install_vs_code.sh

### Cleanup job
RUN bash $INST_SCRIPTS/ubuntu-cleanup.sh && rm -rf $INST_SCRIPTS


EXPOSE 22
EXPOSE 3389
ENTRYPOINT ["/usr/sbin/init"]
