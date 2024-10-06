#!/usr/bin/bash


#                           Auditing/audit-backlog-limit.sh
#                           should be run as root
#                           Author: @martin-montas
#
#       Rationale:
#           during boot if audit=1, then the backlog will hold 64 records. If more that 64 
#           records are created during boot, auditd records will be lost and potential 
#           malicious activity could go undetected.

if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi
RED='\033[0;31m'
GREEN='\033[0;32m'

RESET='\033[0m'


# should return nothing 
AUDIT_BACKLOG_LIMIT=$(grep "^\s*linux" /boot/grub/grub.cfg | grep -v "audit_backlog_limit=")

if [[ -z "$AUDIT_BACKLOG_LIMIT" ]]; then
    echo -e "${RED}[!]${RESET} Audit backlog limit is already set"
    exit 0
else
    echo 'GRUB_CMDLINE_LINUX="audit_backlog_limit=8192"' >> /etc/default/grub

    # updates GRUB
    update-grub

    echo -e "${GREEN}[+]${RESET} Audit backlog limit is set to a proper size. Please reboot system"
    exit 0
fi


