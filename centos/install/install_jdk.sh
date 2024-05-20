#!/usr/bin/env bash
set -e

echo "Install Zulu jdk"
# add the Azul RPM repository
yum install -y https://cdn.azul.com/zulu/bin/zulu-repo-1.0.0-1.noarch.rpm

# install Azul Zulu 17 JDK
yum install -y zulu17-jdk

# maven 3.x
#echo "Install Maven 3.9"
#wget https://repo.huaweicloud.com/apache/maven/maven-3/3.9.2/binaries/apache-maven-3.9.2-bin.tar.gz
#tar -zxf apache-maven-3.9.2-bin.tar.gz && mv apache-maven-3.9.2 /usr/local/maven
#ln -s /usr/local/maven/bin/mvn /usr/local/bin/mvn
#mkdir $HOME/.m2
#rm -rf apache-maven-3.9.2-bin.tar.gz
