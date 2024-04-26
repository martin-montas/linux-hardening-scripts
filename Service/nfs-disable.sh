#!/bin/bash

#                       Service/nfs-disable.sh
#                       should be run as root.
#
#
#               this scripts tries to remove chrony if ntpd or systemd-timesyncd 
#               is already installed. this idea was taken from a cis  benchmark 
#               pdf. and it goes as following:
#               If the system does not export NFS shares or act as an NFS client, 
#               it is recommended that these services be removed to reduce the 
#               remote attack surface.


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi


SERVICE_NAME="nsf-kernel-server"
AVAHI_INSTALLEuD=$(dpkg -l | awk '$2 == "nsf-kernel-server" {print $1}' | grep '^ii') 

if [[ -n $AVAHI_INSTALLED ]]; then
    yes | apt  purge $SERVICE_NAME  >  /dev/null
    echo "$SERVICE_NAME was deleted."
    exit 0
else
    echo "$SERVICE_NAME daemon was not installed."
    exit 0
fi

