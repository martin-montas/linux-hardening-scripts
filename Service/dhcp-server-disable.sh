#!/bin/bash

#                       Service/ldap-disable.sh
#                       should run as root.
#
#               This idea was taken from a CIS  Benchmark PDF. 
#               Rationale: Unless a system is specifically set 
#               up to act as a DHCP server, it is recommended that this 
#
#               by: martin-montas

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi


SERVICE_NAME="isc-dhcp-server"
AVAHI_INSTALLED=$(dpkg -l | awk '$2 == "isc-dhcp-server" {print $1}' | grep '^ii') 

if [[ -n $AVAHI_INSTALLED ]]; then
    yes | apt  purge $SERVICE_NAME  >  /dev/null

    echo "$SERVICE_NAME was deleted."
    exit 0
else
    echo "$SERVICE_NAME daemon was not installed."
    exit 0
fi

