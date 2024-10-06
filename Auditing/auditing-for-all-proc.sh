#!/usr/bin/bash

#               Auditing/auditing-for-all-proc.sh
#               should be run as root
#               Author: @martin-montas
#
#   Rationale:
#       Audit events need to be captured on processes 
#       that start up prior to auditd , so that potential 
#       malicious activity cannot go undetected



RED='\033[0;31m'
GREEN='\033[0;32m'

RESET='\033[0m'

if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit 1
fi

AUDIT_LINUX_LINE=$(grep "^\s*linux" /boot/grub/grub.cfg | grep -v "audit=1")

if [[ -z "$AUDIT_LINUX_LINE" ]]; then
    echo -e "${RED}[!]${RESET} Auditd is already enabled"
    exit 1

else
    # enable auditd
    echo 'GRUB_CMDLINE_LINUX="audit=1"' >> /etc/default/grub

    # updates GRUB
    update-grub

    echo -e "${GREEN}[+]${RESET} Auditd is enabled. Please reboot system"
    exit 0

fi
