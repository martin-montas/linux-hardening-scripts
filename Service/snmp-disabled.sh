#!/bin/bash



#               Service/snmp-disabled.sh
#               should run as root.
#               this idea came about by a CIS benchmark
#               pdf file.
#

if [[ $(id -u) -ne 0 ]]; then
	echo "Please run as root."
	exit 1
fi

IS_INSTALLED=$(dpkg -l | awk '$2 == "snmpd" {print $1, $2}' | grep '^ii')


if [[ -n $IS_INSTALLED ]]; then
    apt-get remove --purge snmpd 
    echo "snmpd has been removed."
    exit 0

else
    echo "snmpd is not installed"
    exit 1
fi
