#!/usr/bin/env bash
set -ex

#yum list installed | grep java
#yum -y remove java-1.7.0-openjdk*
#yum -y remove java-1.8.0-openjdk*
#yum -y remove tzdata-java.noarch

yum -q clean all
rm -rf /var/cache/yum
#yum -q clean all
#yum -y -q update
#yum makecache

if [ ! -e "/opt/rh" ]; then
  mkdir /opt/rh
fi
