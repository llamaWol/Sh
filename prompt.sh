#!/bin/bash

# Highlight color for /
CLR="\033[1;33m"
# Accent used for prefix
PRE="\033[0;97m"
# Default color
RST="\033[0m"

if [ $PWD == $HOME ]; then
	PATH="${PRE}~${CLR}/"
elif [ $PWD == "/" ]; then
	PATH=" ${CLR}/"
elif [[ $PWD =~ ^\/home\/jopie\/[^\/]+$ ]]; then
	PATH="${PRE}~${CLR}/${RST}$(basename $PWD)${CLR}/"
elif [[ $PWD =~ ^\/[^\/]+$ ]]; then
	PATH=" ${CLR}/${RST}$(basename $PWD)${CLR}/"
else
	PATH="${PRE}…${CLR}/${RST}$(basename $PWD)${CLR}/"
fi

echo -e " ${PATH}${PRE} > ${RST}"
