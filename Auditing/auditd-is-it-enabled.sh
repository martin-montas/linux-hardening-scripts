#!/usr/bin/bash

#                     auditd-is-it-enabled.sh
#                     should be run as root
#
#                     Author: @martin-montas
#
#   Rationale:
#       The capturing of system events provides system administrators with 
#       information to allow them to determine if unauthorized access to 
#       their system is occurring.
#

if [ "$EUID" -ne 0 ];
then echo "Please run as root"
    exit
fi

RED='\033[0;31m'
GREEN='\033[0;32m'

RESET='\033[0m'

ENABLED_AUDITD=$(systemctl is-enabled auditd)

if [ "$ENABLED_AUDITD" == "enabled" ]; then
    echo -e "${GREEN}[+]${RESET} Auditd is enabled"
    exit 0
else

    # enable auditd
    systemctl --now enable auditd

    # check if auditd is enabled
    ENABLED_AUDITD=$(systemctl is-enabled auditd)

    if [ "$ENABLED_AUDITD" == "enabled" ]; then
        echo -e "${GREEN}[+]${RESET} Auditd is enabled now"
        exit 0
    else
        echo -e "{$RED}[!]${RESET} Auditd couldn't be enabled"
        exit 1
    fi

fi

