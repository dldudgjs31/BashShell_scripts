#!/bin/bash

cat << EOF
       _ ____   ____   _____ _____   ______          _____    ______ ____    
      | |  _ \ / __ \ / ____/ ____| |  ____|   /\   |  __ \  |____  |___ \    
      | | |_) | |  | | (___| (___   | |__     /  \  | |__) |     / /  __) |   
  _   | |  _ <| |  | |\___ \\___ \  |  __|   / /\ \ |  ___/     / /  |__ <    
 | |__| | |_) | |__| |____) |___) | | |____ / ____ \| |        / /   ___) |   
  \____/|____/_\____/|_____/_____/  |______/_/___ \_\_|   ____/_(_)_|____/___ 
  / ____| |  | |  ____/ ____| |/ / |  __ \|  ____|  __ \ / __ \|  __ \__   __|
 | |    | |__| | |__ | |    | ' /  | |__) | |__  | |__) | |  | | |__) | | |   
 | |    |  __  |  __|| |    |  <   |  _  /|  __| |  ___/| |  | |  _  /  | |   
 | |____| |  | | |___| |____| . \  | | \ \| |____| |    | |__| | | \ \  | |   
  \_____|_|  |_|______\_____|_|\_\ |_|  \_\______|_|     \____/|_|  \_\ |_|                                                                                 
                                                                              
EOF
read -p "이메일을 입력하세요.ex) penta@penta.co.kr  : " EMAIL

DATE=$(date "+%Y-%m-%d")
touch war.txt
grep -r 'runtime-name="' ../configuration/standalone.xml > war.txt
readarray DEPLOY < war.txt
rm -rf war.txt

NUM=0
FRONT=${DEPLOY[$NUM]#*runtime-name=\"}
BACK=${FRONT%%\"*}


while [ "${NUM}" -lt  ${#DEPLOY[*]} ]
do
	FRONT=${DEPLOY[$NUM]#*runtime-name=\"}
	BACK=${FRONT%%\"*}
	DEPLOY[$NUM]=${BACK}
	NUM=$((${NUM} + 1))
done
if [ -e "monitor.${DATE}.log" ]; then
rm -rf monitor.${DATE}.log
else
touch monitor.log
fi
echo "###############Applications Status##############" 
echo "###############Applications Status##############" >> monitor.log

echo "deployment 개수 : ${#DEPLOY[*]}" >> monitor.log
echo "deployment name : ${DEPLOY[*]}" >> monitor.log
echo "###############################################" >> monitor.log
INSTANCE=$(pwd)

for i in ${DEPLOY[*]}
do
	echo $i
	echo "################$i###################" >> monitor.log
	sh ${INSTANCE}/jboss-cli.sh "/deployment=$i:read-resource(include-runtime=true,recursive=true)" | awk 'NR == 15 || (NR >= 16 && NR <= 22) || NR ==27 || (NR>=30 && NR<=31) || (NR>=15 && NR<=47)'  >> monitor.log
done

echo "##########Application monitoring success#######"
echo "###############################################" >> monitor.log
echo "###############################################" >> monitor.log

echo "#############DataSources Status################" >> monitor.log
echo "#############DataSources Status################"
grep -r 'datasource jndi-name="' ../configuration/standalone.xml > data.txt
readarray DATA < data.txt
rm -rf data.txt
NUM1=0

while [ "${NUM1}" -lt  ${#DATA[*]} ]
do
        FRONT=${DATA[$NUM1]#*pool-name=\"}
        BACK=${FRONT%%\"*}
        DATA[$NUM1]=${BACK}
        NUM1=$((${NUM1} + 1))
done
echo "datasource 개수 : ${#DATA[*]}" >> monitor.log
echo "datasource name: ${DATA[*]}" >> monitor.log
for i in ${DATA[*]}
do
	echo $i
	echo "################$i###################" >> monitor.log
sh ${INSTANCE}/jboss-cli.sh "/subsystem=datasources/data-source=$i:read-resource(include-runtime=true,recursive=true)" | awk 'NR==15 || NR==32 || NR ==36 || NR ==45 || (NR>=91&&NR<=92)|| NR==107'  >> monitor.log
done



echo "#####DataSource monitoring success#############"
echo "###############################################" >> monitor.log
echo "###############################################" >> monitor.log
echo "#####################JVM Status################" >> monitor.log
echo "#####################JVM Status################"
echo "#################Memory########################"
echo "#################Memory########################" >> monitor.log
sh ${INSTANCE}/jboss-cli.sh  "/core-service=platform-mbean/type=memory:read-resource(include-runtime=true,recursive=true)" | awk 'NR==15 || (NR>=17&&NR<=21) || (NR>=23&&NR<=27)' >> monitor.log
echo "#################Threading#####################"
echo "#################Threading#####################" >> monitor.log
touch thread.txt
sh ${INSTANCE}/jboss-cli.sh  "/core-service=platform-mbean/type=threading:read-resource(include-runtime=true,recursive=true)" > thread.txt
(grep -r '"thread-count"' thread.txt && grep -r 'daemon-thread-count' thread.txt) >> monitor.log
rm -rf thread.txt
echo "###########JVM monitoring success##############"

echo "###############################################" >> monitor.log
echo "###############################################" >> monitor.log
echo "#####################WEB Status################" >> monitor.log
echo "#####################WEB Status################"
echo "########################AJP####################"

sh ${INSTANCE}/jboss-cli.sh "/subsystem=undertow/server=default-server/ajp-listener=ajp:read-resource(include-runtime=true,recursive=true)" | awk 'NR>=15&&NR<=100' >> monitor.log
echo "###########WEB monitoring success##############"
mv monitor.log monitor.${DATE}.log
cat monitor.${DATE}.log | mail -s "[정기점검${DATE}] JBOSS EAP 7.3" ${EMAIL}

