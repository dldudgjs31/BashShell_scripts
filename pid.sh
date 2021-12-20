#!/bin/bash
PID="/opt/test/apache/jbcs-httpd24-2.4/httpd/run/httpd.pid"
if [ -e "${PID}" ]; then
	kill -9 pid number		
else 
	echo "apache가 실행중이 아닙니다."
fi
