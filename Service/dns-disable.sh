#!/bin/bash

#                       Service/nfs-disable.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to the CIS 
#               Benchmark. Rationale:
#               If the system does not export NFS shares or act as an NFS client, 
#               it is recommended that these services be removed to reduce the 
#               remote attack surface.


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE_NAME="bind9"
INSTALLED=$(dpkg -l | awk '$2 == "bind9" {print $1}' | grep '^ii') 

if [[ -n $INSTALLED ]]; then
    yes | apt  purge $SERVICE_NAME  >  /dev/null
    echo "$SERVICE_NAME was deleted."
    exit 0

else
    echo "$SERVICE_NAME daemon was not installed."
    exit 0
fi
