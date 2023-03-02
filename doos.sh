#!/bin/bash

install () {
	echo -e "\033[1;32;102m\n+ ${@}\n\033[0m\n"

	ROOT=""
	if (( $EUID != 0 )); then
		ROOT="sudo"
	fi

	$ROOT xbps-install ${@}
}

remove () {
	echo -e "\033[1;31;101m\n- ${@}\n\033[0m\n"
	
	ROOT=""
	if (( $EUID != 0 )); then
		ROOT="sudo"
	fi

	$ROOT xbps-remove -R ${@}
}

update () {
	echo -e "\033[1;33;103m\n…\n\033[0m\n"
	
	ROOT=""
	if (( $EUID != 0 )); then
		ROOT="sudo"
	fi

	$ROOT xbps-install -Su
}

query () {
	for pkg in "$@"; do
		echo -e "\033[1;34;104m\n? ${pkg}\n\033[0m\n"
		
		xbps-query -R $pkg
	done
}

help () {
	echo "
Usage: doos [option] [value]

Options:
  i -> Install package(s)
    |  xbps-install <pkg>
  
  r -> Remove packages(s)
    |  xbps-remove -R <pkg>
  
  u -> Update installed packages
    |  xbps-install -Su
  
  q -> Find package(s)
    |  xbps-query -R <pkg>
	" 
	exit 1
}

# From:
# https://stackoverflow.com/a/66731653
function getopts-extra () {
    declare i=1
    # if the next argument is not an option, then append it to array OPTARG
    while [[ ${OPTIND} -le $# && ${!OPTIND:0:1} != '-' ]]; do
        OPTARG[i]=${!OPTIND}
        let i++ OPTIND++
    done
}

while getopts :i:q:r:uh OPT; do
	case $OPT in	
    	i) getopts-extra "$@"
           install "${OPTARG[@]}"
           # Empty OPTARG array, or else things go south when using -i, -r & -q together
           OPTARG=()
           ;;
    	r) getopts-extra "$@"
           remove "${OPTARG[@]}"
           # Empty OPTARG array
           OPTARG=()
           ;;
    	q) getopts-extra "$@"
           query "${OPTARG[@]}"
           # Empty OPTARG array
           OPTARG=()
           ;;
    	u) update;;
		:) echo "Missing argument for ${OPTARG}"
		   help
		   ;;
	   \?) echo "Illegal option: ${OPTARG}"
		   help
		   ;;
    esac
done

if ! [[ "$1" =~ \-[irquh] ]]; then
	help
fi
