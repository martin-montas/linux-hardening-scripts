#!/bin/bash

#                       Service/ldap-client-disable.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to the CIS 
#               Benchmark. Rationale:
#               If the system will not need to act as an LDAP client, 
#               it is recommended that the software be removed to reduce 
#               the potential attack surface.

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE="ldap-utils"
INSTALLED=$(dpkg -l | awk  '$2 == "ldap-utils" {print $1}' | grep '^ii') 

if [[ -n $INSTALLED ]]; then
    yes | apt  purge $SERVICE  >  /dev/null

fi

