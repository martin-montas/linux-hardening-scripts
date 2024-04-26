#!/bin/bash

#                       Service/ftp-disable.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to the CIS 
#               Benchmark. Rationale:
#               FTP does not protect the confidentiality of data or authentication credentials. It is
#               recommended SFTP be used if file transfer is required. Unless there is a need to run the
#               system as a FTP server (for example, to allow anonymous downloads), it is recommended
#               that the package be deleted to reduce the potential attack surface.

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE_NAME="vsftpd"
INSTALLED=$(dpkg -l | awk -v var="$SERVICE_NAME" '$2 == "vsftpd" {print $1}' | grep '^ii') 

if [[ -n $INSTALLED ]]; then
    yes | apt  purge $SERVICE_NAME  >  /dev/null
    echo "$SERVICE_NAME was deleted."
    exit 0

else
    echo "$SERVICE_NAME daemon was not installed."
    exit 0
fi
