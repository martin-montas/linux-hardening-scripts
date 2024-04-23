#!/bin/bash



#               Service/samba-disabled.sh
#               should run as root.
#               this idea came about by a CIS benchmark
#               pdf file.
#



if [[ $(id -u) -ne 0 ]]; then
	echo "Please run as root."
	exit 1
fi

IS_INSTALLED=$(dpkg -l | awk '$2 == "samba" {print $1, $2}' | grep '^ii')


if [[ -n $IS_INSTALLED ]]; then
    sudo apt-get remove --purge samba
    echo "samba has been removed. "
    exit 0

else
    echo "samba is not installed"
    exit 1
fi
