#!/bin/bash

function plus {
	echo "$1 + $2 = "
	echo $[ $1 + $2 ]
	echo
}

function minus {
	echo "$1 - $2 = "
	echo $[ $1 - $2]
	echo
}


function multi {
        echo "$1 * $2 = "
        echo $[ $1 * $2]
        echo
}

function div {
        echo "$1 / $2 = "
        if [ $2 -eq 0 ]
	then
		echo "0 is impossible"
	else
		echo $[ $1 / $2 ]
	fi
        echo
}





