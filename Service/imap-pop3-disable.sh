#!/bin/bash

#                       Service/ftp-disable.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to the CIS 
#               Benchmark. Rationale:
#               Unless POP3 and/or IMAP servers are to be provided by this system, it is recommended
#               that the package be removed to reduce the potential attack surface.

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

POP3="dovecot-pop3d"
IMAP="dovecot-imapd"
INSTALLED_POP3=$(dpkg -l | awk -v var="$POP3" '$2 == "var" {print $1}' | grep '^ii') 
INSTALLED_IMAP=$(dpkg -l | awk -v var="$IMAP" '$2 == "var" {print $1}' | grep '^ii') 
ALL_INSTALLED=0


if [[ -n $INSTALLED_IMAP ]]; then
    yes | apt  purge $IMAP  >  /dev/null
    (( ALL_INSTALLED += 1 ))
fi

if [[ -n $INSTALLED_POP3 ]]; then
    yes | apt  purge $POP3  >  /dev/null
    (( ALL_INSTALLED += 1 ))
fi

if [[ $ALL_INSTALLED == 1 ]]; then
    echo "Only one was deleted."

elif [[ $ALL_INSTALLED == 2 ]];  then
    echo "All were deleted."
else
    echo "None were deleted or were installed."
fi
