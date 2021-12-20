#! /bin/bash
read -p "write directory that you want to know :  " DIR
if [ -d "$DIR" ]; then
	echo "$DIR is not Empty"
else
	echo "$DIR is Empty"
fi
