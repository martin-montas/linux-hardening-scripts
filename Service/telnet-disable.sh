#!/bin/bash

#                       Service/telnet-disable.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to the CIS 
#               Benchmark. Rationale:
#
#               The telnet protocol is insecure and unencrypted. The use 
#               of an unencrypted transmission medium could allow an 
#               unauthorized user to steal credentials. The ssh package provides
#               an encrypted session and stronger security and is included in most 
#               Linux distributions.

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE="telnet"
INSTALLED=$(dpkg -l | awk  '$2 == "telnet" {print $1}' | grep '^ii') 

if [[ -n $INSTALLED ]]; then
    yes | apt  purge $SERVICE  >  /dev/null
else
    echo "$SERVICE was not installed."
fi

