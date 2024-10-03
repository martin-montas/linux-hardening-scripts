#!/bin/bash

#                       Service/squid-disable.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to the CIS 
#               Benchmark. Rationale:
#               If there is no need for a proxy server, it is recommended that the squid proxy be deleted to
#               reduce the potential attack surface.

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE="squid"
INSTALLED=$(dpkg -l | awk  '$2 == "squid" {print $1}' | grep '^ii') 

if [[ -n $INSTALLED ]]; then
    yes | apt  purge $SERVICE  >  /dev/null

fi

