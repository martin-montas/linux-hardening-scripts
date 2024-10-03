#!/bin/bash

#                       Service/talk-disable.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to the CIS 
#               Benchmark. Rationale:
#               The software presents a security risk as it uses unencrypted 
#               protocols for communication.


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE="talk"
INSTALLED=$(dpkg -l | awk  '$2 == "talk" {print $1}' | grep '^ii') 

if [[ -n $INSTALLED ]]; then
    yes | apt  purge $SERVICE  >  /dev/null

fi

