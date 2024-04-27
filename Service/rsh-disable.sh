#!/bin/bash
#                       Service/rsh-disable.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to the CIS 
#               Benchmark. Rationale:
#
#
#

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE="rsh-client"
INSTALLED=$(dpkg -l | awk  '$2 == "rsh-client" {print $1}' | grep '^ii') 

if [[ -n $INSTALLED ]]; then
    yes | apt  purge $SERVICE  >  /dev/null

else
    echo "The service wasn't installed."
fi

