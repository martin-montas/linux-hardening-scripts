#!/bin/bash

#                       Service/chrony-disable.sh
#                       should be run as root.
#
#
#               this scripts tries to remove chrony if ntpd or systemd-timesyncd 
#               is already installed.
#               this idea was taken from a cis  benchmark pdf. and it 
#               goes as following:
#               "If ntp or systemd-timesyncd are used, chrony should be removed"
#               "Only one time synchronization method should be in use on the system"


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

NTPD=0
SYSTEMD_TIMESYNCD=0
CHRONY=0

# Check if ntpd service is running and enabled
if systemctl is-active --quiet ntpd && systemctl is-enabled --quiet ntpd; then
    NTPD+=1
fi

# Check if systemd-timesyncd service is running and enabled
if systemctl is-active --quiet systemd-timesyncd && systemctl is-enabled --quiet systemd-timesyncd; then
    SYSTEMD_TIMESYNCD+=1
fi

# Check if systemd-timesyncd service is running and enabled
if systemctl is-active --quiet chrony && systemctl is-enabled --quiet chrony; then
    CHRONY+=1
fi

if [[ $NTPD == 1 && $SYSTEMD_TIMESYNCD == 1 ]]; then
    echo "You should only have one time synchronization method."
    echo "Currently you have ntpd and systemd-timesyncd."
fi

if [[ $NTPD == 1 && $CHRONY == 1 ]]; then
    echo "You should only have one time synchronization method."
    echo "Currently you have ntpd and chrony"
fi

if [[ $SYSTEMD_TIMESYNCD == 1 && $CHRONY == 1 ]]; then
    echo "You should only have one time synchronization method."
    echo "Currently you have systemd-timesyncd and chrony"
fi
