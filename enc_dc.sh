#!/bin/sh

export JBOSS_HOME=/opt/jboss/jboss-eap-7.2
export CLASSPATH=${JBOSS_HOME}/modules/system/layers/base/org/picketbox/main/picketbox-5.0.3.Final-redhat-3.jar
export CLASSPATH=$CLASSPATH:${JBOSS_HOME}/modules/system/layers/base/org/jboss/logging/main/jboss-logging-3.3.2.Final-redhat-00001.jar

java -cp $CLASSPATH org.picketbox.datasource.security.SecureIdentityLoginModule $1

