#!/bin/bash

#                   service/avahi-disable.sh
#                   should run as root.
#
#                   this script idea was taken from a CIS Benchmark
#                   pdf file.
#

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

AVAHI_INSTALLED=$(dpkg -l | awk '$2 == "avahi-daemon" {print $1, $2}' | grep '^ii') 

if [[ -n $AVAHI_INSTALLED ]]; then
    systemctl stop avahi-daemon.service > /dev/null
    systemctl stop avahi-daemon.socket > /dev/null
    apt  purge avahi-daemon > /dev/null > /dev/null

    echo "Avahi-daemon was deleted."
    exit 0
else
    echo "avahi daemon was not installed."
    exit 0
fi

