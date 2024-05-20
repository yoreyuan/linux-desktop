#!/usr/bin/env bash
set -ex

echo "INSTALL_IDEA=$$INSTALL_IDEA"
if [ "false" = "$INSTALL_IDEA" ]; then
  echo "The IDEA installation will be skipped!"

  if [ "true" = "$INSTALL_MAVEN" ]; then
    # maven 3.x
    echo "Install Maven 3.9"
    wget https://repo.huaweicloud.com/apache/maven/maven-3/3.9.2/binaries/apache-maven-3.9.2-bin.tar.gz
    tar -zxf apache-maven-3.9.2-bin.tar.gz && mv apache-maven-3.9.2 /usr/local/maven
    ln -s /usr/local/maven/bin/mvn /usr/local/bin/mvn
    if [ ! -e "$HOME/.m2" ]; then
      mkdir $HOME/.m2
    fi
    rm -rf apache-maven-3.9.2-bin.tar.gz
  fi

  exit 0
fi

ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/x64/g')
IDEA_VERSION=$1

if [ "" = "$IDEA_VERSION" ]; then
  IDEA_VERSION="2023.2.1"
fi

echo "Start installing IDEA!"

#https://www.jetbrains.com/idea/download/other.html
if [ ! -e "$INST_SCRIPTS/idea-${IDEA_VERSION}.tar" ]; then
  if [ "$ARCH" == "arm64" ] ; then
    wget https://download.jetbrains.com/idea/ideaIC-${IDEA_VERSION}-aarch64.tar.gz -O $INST_SCRIPTS/idea-${IDEA_VERSION}.tar
  else
    wget https://download.jetbrains.com/idea/ideaIC-${IDEA_VERSION}.tar.gz -O $INST_SCRIPTS/idea-${IDEA_VERSION}.tar
  fi
fi

if [ ! -e "/opt/idea" ]; then
  mkdir /opt/idea
fi
tar -zxf $INST_SCRIPTS/idea-${IDEA_VERSION}.tar --strip-components=1 -C /opt/idea/

cat >> $HOME/Desktop/IDEA.desktop <<EOF
[Desktop Entry]
Name=IDEA
Comment=idea-IU
Icon=/opt/idea/bin/idea.png
Exec=/opt/idea/bin/idea.sh
Terminal=false
Type=Application
NoDisplay=false
Categories=Application;Development;
EOF

chmod +x $HOME/Desktop/IDEA.desktop
cp $HOME/Desktop/IDEA.desktop /usr/share/applications/


#########################
# use IDEA maven
if [ "true" = "$INSTALL_MAVEN" ]; then
  ln -s /opt/idea/plugins/maven/lib/maven3 /usr/local/maven
  ln -s /usr/local/maven/bin/mvn /usr/local/bin/mvn
  if [ ! -e "$HOME/.m2" ]; then
    mkdir $HOME/.m2
  fi
fi
