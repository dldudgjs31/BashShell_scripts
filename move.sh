#!/bin/sh

PATH=$PATH:$HOME/bin
JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.282.b08-1.el7_9.i386
export PATH
export JAVA_HOME

MAVEN_HOME=/opt/installFile/apache-maven-3.8.1

PATH=$PATH:$MAVEN_HOME/bin

export MAVEN_HOME


cd /opt/github/boot-test
git pull origin
echo "git clear"
cd /opt/github/boot-test/jboss
mvn package
echo "mvn clear"
