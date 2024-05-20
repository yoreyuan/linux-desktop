一个Linux的desktop环境
==================

# 1 Overview
Docker + RDP + 远程桌面连接方式，可以在Windows系统快速搭建一个Linux环境，简单、方便且易用。

目前支持如下操作系统环境：
* Ubuntu 22.04.3
* Centos 7.9.2009 (尽管默认的是GNOME桌面，但推荐使用XFCE)

开发环境中提供如下
* Chrome
* Git
  - CentOS: 2.42.0
  - Ubuntu: 2.34.1
* IDEA
* JDK 17
* Maven 3
* Python 3
* RDP
* SSH
* 等等

# 2 Features
* 镜像以Docker的方式提供, 意味着只要支持Docker的系统, 都可以快速部署此环境;
* Linux系统以比较常用的Ubuntu/Centos官方镜像为基础镜像进行构建;
* 镜像提供了Desktop可视化桌面;
* 支持通过SSH（可以通过ssh工具访问）和Windows的远程桌面方式访问系统;
* 支持RDP，其优点就是画面中静态的内部不会传输，仅传输远程端控件属性变化的数据。既节约带宽，又对硬件压力较小;
* Ubuntu 22.04默认桌面为 Gnome 3, 相对比较重。这里选择了比较轻量的XFCE 4桌面;
* Centos支持 GNOME/KDE/XFCE4, 默认是GNOME, 但推荐更轻量的XFCE4
* 非常适合Windows系统下，需要使用Linux开发的同学。对于不支持Windows（或支持不太好的）的项目不必为了在Windows系统中运行项目而修改大量代码,通过Docker volume可以在两个系统直接随意切换;
* 支持比较完整的命令（例如`systemctl`）,例如相比于**kasmweb**提供的镜像;


# 3 Quickstart

## 3.1 CentOS
进入到**centos**目录下。

### 3.1.1 构建镜像
为了加速构建，可以提前将如下包放到 `centos/install`
* chrome.rpm
* git.tar
* idea-2023.2.1.tar

#### 默认方式构建镜像
Windows环境可以执行如下命令构建镜像：
```bash
./build.bat
```

Linux环境可以执行如下命令构建镜像：
```bash
./build.sh
```

#### 构建XFCE4桌面镜像
```bash
docker build . -f Dockerfile -t linuxenv:centos7.9.2009 --build-arg "DESKTOP_TYPE=Xfce"
```

#### 构建GNOME桌面镜像
```bash
docker build . -f Dockerfile -t linuxenv:centos7.9.2009 --build-arg "DESKTOP_TYPE=GNOME"
```

#### 构建KDE桌面镜像
```bash
docker build . -f Dockerfile -t linuxenv:centos7.9.2009 --build-arg "DESKTOP_TYPE=KDE"
```

#### 其他可选构建参数
* `--build-arg "INSTALL_CHROME=false"`: 不安装Chrome浏览器, 默认安装
* `--build-arg "INSTALL_DOCKER=true"`: 安装Docker, 默认不安装
* `--build-arg "INSTALL_IDEA=false"`: 不安装IDEA, 默认安装
* `--build-arg "INSTALL_MAVEN=false"`: 不安装Maven, 默认安装
* `--build-arg "INSTALL_SUBLIME_TEST=true"`: 安装 Sublime Test，XFCE4默认安装，其他桌面时默认不安装


### 3.1.2 启动容器
使用docker-compose启动
```bash
docker-compose -f docker-compose.yaml up -d
```

### 3.1.3 关闭
使用docker-compose关闭
```bash
docker-compose -f docker-compose.yaml stop
```

### 3.1.4 通过SSH方式访问
默认root用户的密码为 `123456`, 端口为 3022
```bash
ssh -p 3022 root@localhost
```

### 3.1.5 通过Windows自带的远程桌面连接
在Windows下按`Windows + R`，并输入`mstsc`以打开**远程桌面连接**，在结算机输入框中输入： `127.0.0.1:3388`,
用户名root对应的默认密码为123456。成功进入后可以看到熟悉的Ubuntu桌面。
如果卡住或者黑屏、闪退，可以到用户的家目录下查看 `~/.xorgxrdp.10.log`、`~/.xsession-errors`文件信息，来定位及解决。

### 3.1.6 Windows远程桌面连接优化
* 显示：显示配置可以滑动到最右边，这样可以在多个显示器中都以全屏的方式显示。
* 体验：因为是连接本地的，可以选择为`LAN (10 Mbps或更高)`，可以使得画面更加流畅。
* 本地资源：本地设备和资源，驱动器，可以将本地磁盘在远程服务器上访问。



## 3.2 Ubuntu
进入到**ubuntu**目录下。

### 3.2.1 构建镜像
为了加速构建，可以提前将如下包放到 `ubuntu/install`
* chrome.deb
* idea-2023.2.1.tar

#### 默认方式构建镜像
Windows环境可以执行如下命令构建镜像：
```bash
./build.bat
```

Linux环境可以执行如下命令构建镜像：
```bash
./build.sh
```

#### 构建XFCE4桌面镜像
```bash
docker build . -f Dockerfile -t linuxenv:latest --build-arg "DESKTOP_TYPE=Xfce"

# 同时安装开启docker
docker build . -f Dockerfile -t linuxenv:latest --build-arg "DESKTOP_TYPE=Xfce" --build-arg "INSTALL_DOCKER=true"
```

XFCE4中文
```bash
apt-get -y install locales xfonts-intl-chinese fonts-wqy-microhei

# 根据提示选择中文即可
dpkg-reconfigure locales
# 492. zh_CN.UTF-8 UTF-8
# 3. zh_CN.UTF-8
```

关于中文输入法，例如可以参考搜狗的
* [安装指南](https://shurufa.sogou.com/linux/guide)
* [下载](https://shurufa.sogou.com/?r=mac&t=pinyin)

#### 构建GNOME桌面镜像
```bash
docker build . -f Dockerfile -t linuxenv:latest --build-arg "DESKTOP_TYPE=GNOME"
```

#### 构建Deepin桌面镜像
```bash
 docker build . -f Dockerfile -t linuxenv-deepin:latest --build-arg "DESKTOP_TYPE=Deepin"
```

#### 其他可选构建参数
* `--build-arg "INSTALL_CHROME=false"`: 不安装Chrome浏览器, 默认安装
* `--build-arg "INSTALL_CHROMIUM=true"`: 安装Chromium浏览器, 默认不安装
* `--build-arg "INSTALL_DOCKER=true"`: 安装Docker, 默认不安装
* `--build-arg "INSTALL_FIREFOX=true"`: 安装Firefox浏览器, 默认不安装
* `--build-arg "INSTALL_IDEA=false"`: 不安装IDEA, 默认安装
* `--build-arg "INSTALL_MAVEN=false"`: 不安装Maven, 默认安装
* `--build-arg "INSTALL_SUBLIME_TXST=true"`: 安装 Sublime Text，XFCE4默认安装，其他桌面时默认不安装
* `--build-arg "INSTALL_VS_CODE=true"`: 安装VS Code, 默认不安装

### 3.2.2 使用
使用同 3.1 中的使用说明。

