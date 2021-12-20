#!/bin/bash
cat << "EOF"
       __ ____   ____  _____ _____             
      / // __ ) / __ \/ ___// ___/             
 __  / // __  |/ / / /\__ \ \__ \              
/ /_/ // /_/ // /_/ /___/ /___/ /              
\____//_____/ \____//____//____/               
    ____ _   __ _____ ______ ___     __     __ 
   /  _// | / // ___//_  __//   |   / /    / / 
   / / /  |/ / \__ \  / /  / /| |  / /    / /  
 _/ / / /|  / ___/ / / /  / ___ | / /___ / /___
/___//_/ |_/ /____/ /_/  /_/  |_|/_____//_____/

EOF
##read directory that i want to make domain for jboss instance
ARR=( $(find / -name 'jboss-eap*.zip') )
NUM=1

echo "-------------------install file list---------------------"

for VALUE in "${ARR[@]}"; do
echo "$NUM) [$VALUE]"
((NUM+=1));
done
echo "total : ${#ARR[@]}"
echo "-------------------install file list---------------------"

read -p "choose the number which you want to install  : " DIR_NUM 

v=$DIR_NUM
r=${v//[0-9]/}
while [ ! -z "$r" ]; do
    	echo "$v is not number."
    	read -p "choose the number which you want to install  : " DIR_NUM
	v=$DIR_NUM
	r=${v#-}
	r=${v//[0-9]/}

done
while [ "$DIR_NUM" -gt "${#ARR[@]}" ];
do
	echo "you can choose the number between 1 and ${#ARR[@]}"
	read -p "choose the number which you want to install : " DIR_NUM
done
DIR_NUM=$((DIR_NUM-1))

read -p "write down the path to install (ex)/opt/jboss :  " INS_PATH
JBOSS_PATH=$(echo ${ARR[$DIR_NUM]} | rev | cut -d'/' -f1 | rev)
JBOSS_PATH=$(echo ${JBOSS_PATH%.0*p})

if [ ! -e  $INS_PATH/$JBOSS_PATH ]; then
#if [ ! -e  $INS_PATH/$JBOSS_PATH ]; then
 	echo "wait! jboss is being installed................."
	echo $INS_PATH
	echo ${ARR[$DIR_NUM]}
	unzip ${ARR[$DIR_NUM]} -d $INS_PATH
else 
	echo "jboss is already installed..."
	read -p  "Do you want to use same jboss engine? y/n : " REP

	if [ "$REP" == "y" ]; then
		echo "Okay.. keep going..."
	else
		exit
	fi
fi

if [ -d $INS_PATH/jboss-eap* ]; then 
	echo "${ARR[$DIR_NUM]} is installed successfully"
else
	echo "fail....."
	exit
fi




ENGINE_DIR=$INS_PATH
JBOSS=$(echo ${ARR[$DIR_NUM]} | rev | cut -d'/' -f1 | rev)
JBOSS=$(echo ${JBOSS%.0*p})



read -p "enter the domains name what you want to make : " DOMAIN_DIR

while [ -d "$ENGINE_DIR"/"$DOMAIN_DIR" ];
do
	echo "$DOMAIN_DIR already exists"
	read -p "Do you want to use same domain directory? y/n :  " RE
	if [ $RE == "y" ];then
		break
	elif [ $RE == "n" ];then
		read -p "enter the domains name what you want to make : " DOMAIN_DIR
		mkdir -v $ENGINE_DIR/$DOMAIN_DIR
	fi
done

read -p "enter the instance name what you want to make for jboss instance : " INSTANCE_NAME

until [ ! -e $ENGINE_DIR/$DOMAIN_DIR/$INSTANCE_NAME ]; do
	echo "$ENGINE_DIR/$DOMAIN_DIR/$INSTANCE_NAME is already exists"
	read -p "enter the instance name what you want to make for jboss instance : " INSTANCE_NAME

done
echo $ENGINE_DIR/$DOMAIN_DIR/$INSTANCE_NAME
echo $JBOSS
mkdir -v $ENGINE_DIR/$DOMAIN_DIR/$INSTANCE_NAME
mkdir -pv $ENGINE_DIR/$DOMAIN_DIR/$INSTANCE_NAME/log/{gclog,heap,nohup}
touch $ENGINE_DIR/$DOMAIN_DIR/$INSTANCE_NAME/log/server.log
mkdir -v $ENGINE_DIR/$DOMAIN_DIR/$INSTANCE_NAME/bin
cp -r $ENGINE_DIR/$JBOSS/standalone/* $ENGINE_DIR/$DOMAIN_DIR/$INSTANCE_NAME/



echo "clear!"




