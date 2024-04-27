#!/bin/bash

#                       Service/rpcbind-disable.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to the CIS 
#               Benchmark. Rationale:
#
#               If RPC is not required, it is recommended that this 
#               services be removed to reduce the remote attack surface.


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE="rpcbind"
INSTALLED=$(dpkg -l | awk  '$2 == "rpcbind" {print $1}' | grep '^ii') 

if [[ -n $INSTALLED ]]; then
    yes | apt  purge $SERVICE  >  /dev/null
else
    echo "the program wasn't found."

fi

