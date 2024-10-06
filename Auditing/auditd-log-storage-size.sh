#!/usr/bin/bash

#                   ./Auditing/auditd-log-storage-size.sh
#                   should be run as root
#                   Author: @martin-montas
#
#   Rationale:
#       It is important that an appropriate size is determined for log files so 
#       that they do not impact the system and audit data is not lost#

if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi

RED='\033[0;31m'
GREEN='\033[0;32m'

RESET='\033[0m'

MAX_LOG_FILE_NUM=$(grep -P '^max_log_file\s' /etc/audit/auditd.conf)

if [[ -z "$MAX_LOG_FILE_NUM" ]]; then
    echo 'max_log_file = 8' >> /etc/audit/auditd.conf
    echo -e "${GREEN}[+]${RESET} Max log file number set to 8 for Auditd"
    exit 1
else
    echo -e "${RED}[!]${RESET} Max log file number is already set for Auditd"
    exit 0
fi
