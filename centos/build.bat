
@REM 指定为 KDE
@REM docker build . -f Dockerfile -t linuxenv-kde:centos7.9.2009 --build-arg "DESKTOP_TYPE=KDE"

@REM 默认为 GNOME
@REM docker build . -f Dockerfile -t linuxenv-gnome:centos7.9.2009 --build-arg "DESKTOP_TYPE=GNOME"

@REM 指定为 Xfce
@REM docker build . -f Dockerfile -t linuxenv-xfce:centos7.9.2009 --build-arg "DESKTOP_TYPE=Xfce"
@REM 同时安装开启docker
@REM docker build . -f Dockerfile -t linuxenv-xfce:centos7.9.2009 --build-arg "DESKTOP_TYPE=Xfce" --build-arg "INSTALL_DOCKER=true"

@REM 默认为 GNOME
docker build . -f Dockerfile -t linuxenv:centos7.9.2009
