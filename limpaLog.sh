#!/bin/bash
TOMCAT_HOME=$1

DATA=`date "+%Y%m%d"`

cp ${TOMCAT_HOME}/logs/catalina.out ${TOMCAT_HOME}/logs/catalina.out.${DATA}.bak

>  ${TOMCAT_HOME}/logs/catalina.out

find  ${TOMCAT_HOME}/logs -mtime +20 -type f -exec rm -f {} \;

