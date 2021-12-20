#!/bin/bash

#정보 담을 파일 생성
touch report

#report파일 초기화
cp -f /dev/null report
 

## > => overwrite >> => append
{
	df -h >> report
	pstree >> report
	free -m >> report
	uptime >> report
} >> report
#위 결과 이메일로 전송 
# 이메일 보내는 커맨드
cat report | mail -s "[report] younghun system info" dldudgjs31@naver.com
