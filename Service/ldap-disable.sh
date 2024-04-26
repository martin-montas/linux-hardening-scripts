#!/bin/bash


#                       Service/ldap-disable.sh
#                       should be run as root.
#
#               this idea was taken from a CIS  Benchmark PDF. and it 
#               goes as following: If the system will not need to act 
#               as an LDAP server, it is recommended that the software 
#               be removed to reduce the potential attack surface.
#
#               by: martin-montas

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE_NAME="slapd"
AVAHI_INSTALLED=$(dpkg -l | awk '$2 == "slapd" {print $1}' | grep '^ii') 

if [[ -n $AVAHI_INSTALLED ]]; then
    yes | apt  purge $SERVICE_NAME  >  /dev/null
    echo "$SERVICE_NAME was deleted."
    exit 0
else
    echo "$SERVICE_NAME daemon was not installed."
    exit 0
fi

