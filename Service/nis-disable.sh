#!/bin/bash

#                       Service/nis-disable.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to the CIS 
#               Benchmark. Rationale:
#
#               The NIS service is inherently an insecure system that has been vulnerable to DOS attacks,
#               buffer overflows and has poor authentication for querying NIS maps. NIS generally has
#               been replaced by such protocols as Lightweight Directory Access Protocol (LDAP). It is
#               recommended that the service be removed and other, more secure services be used

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE="nis"
INSTALLED=$(dpkg -l | awk  '$2 == "nis" {print $1}' | grep '^ii') 

if [[ -n $INSTALLED ]]; then
    yes | apt  purge $SERVICE  >  /dev/null
else
    echo "There service was not installed."
fi

