
@REM 默认为 GNOME
@REM docker build . -f Dockerfile -t linuxenv-gnome:latest --build-arg "DESKTOP_TYPE=GNOME"

@REM 指定为 Xfce
@REM docker build . -f Dockerfile -t linuxenv-xfce:latest --build-arg "DESKTOP_TYPE=Xfce"
@REM 同时安装开启docker
@REM docker build . -f Dockerfile -t linuxenv-xfce:latest --build-arg "DESKTOP_TYPE=Xfce" --build-arg "INSTALL_DOCKER=true"

@REM 默认为 GNOME
docker build . -f Dockerfile -t linuxenv:latest
