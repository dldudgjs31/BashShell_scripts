#!/bin/bash

cat << "EOF"

     ██╗██████╗  ██████╗ ███████╗███████╗      
     ██║██╔══██╗██╔═══██╗██╔════╝██╔════╝      
     ██║██████╔╝██║   ██║███████╗███████╗      
██   ██║██╔══██╗██║   ██║╚════██║╚════██║      
╚█████╔╝██████╔╝╚██████╔╝███████║███████║      
 ╚════╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝      
 ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ 
██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ 
██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
 ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝ 

EOF

echo "------------------------warming-----------------------------------"
echo "Before use, you need to move the env.sh file to the bin directory."
echo "------------------------------------------------------------------"
VAL=0
read -p "Do you want to exit the script? y/n : " ANS
while [ "$VAL"==1 ]; 
do
	if [ "$ANS" == "y" -o "$ANS" == "yes" ];then
		exit
	elif [ "$ANS" == "n" -o "$ANS" == "no" ]; then
		VAL=1
		echo "keep going"
		break
	else
	 	echo "again..."
		read -p "Do you want to exit the script? y/n : " ANS
	fi
done
read -p "enter your bin's directory (ex)/opt/jboss/node01/bin : " BIN
read -p "enter JBOSS_HOME : " JBOSS_C
read -p "enter DOMAIN_BASE : " DOMAIN_DIR_C
read -p "enter CONFIG_FILE (enter the number (1)standard (2)ha ) : " CONFIG_C

if [ $CONFIG_C == "1" ]; then
CONFIG_C=standalone.xml
else
CONFIG_C=standalone-ha.xml
fi

read -p "enter SERVER_NAME : "  INSTANCE_DIR_C
read -p "enter JBOSS_USER : " USERNAME_C
read -p "enter BIND_ADDR : " ADDR_C
read -p "enter PORT_OFFSET : " OFFSET_C

sed -i 's/$ABC/'"$JBOSS_C"'/' $BIN/env.sh
sed -i 's/$ABCD/'"$DOMAIN_DIR_C"'/' $BIN/env.sh
sed -i 's/$INSTANCE_NAME/'"$INSTANCE_DIR_C"'/' $BIN/env.sh
sed -i 's/$CONFIG/'"$CONFIG_C"'/' $BIN/env.sh
sed -i 's/$USERNAME/'"$USERNAME_C"'/' $BIN/env.sh
sed -i 's/$OFFSET/'"$OFFSET_C"'/' $BIN/env.sh
sed -i 's/$ADDR/'"$ADDR_C"'/' $BIN/env.sh
echo "clear! check env.sh! thanks"





