#!/bin/bash
#
#
x=(whoami)

if [[ $x -eq  centos ]]
then
	echo "root user is correct"

else
	echo "not correct"
fi

