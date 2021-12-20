#!/bin/bash

#read -sp "화면에 출력할 문자" 변수이름

NUM=0
LOTTO=()
GOAL=$(($RANDOM% 45+1))

for NUM in $(seq 1 6)
	${GOAL}=$(($RANDOM% 45+1))
	${LOTTO[${NUM}]}=${GOAL}
	NUM=$((${NUM} +1 ))
done
echo ${LOTTO[*]}
