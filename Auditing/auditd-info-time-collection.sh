#!/usr/bin/bash


#                   ./Auditing/auditd-info-time-collection.sh
#                   should be run as root
#                   Author: @martin-montas
#
#   Rationale:
#       Unexpected changes in system date and/or time could be a 
#       sign of malicious activity on the system

if [ "$EUID" -ne 0 ];
then echo "Please run as root"
    exit 1
fi


RED='\033[0;31m'
GREEN='\033[0;32m'

RESET='\033[0m'


VERIFY_RULES=$(uname -m)

EXPECTED_OUTPUT_64=" always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-
change
-a always,exit -F arch=b64 -S clock_settime -k time-change
-a always,exit -F arch=b32 -S clock_settime -k time-change
-w /etc/localtime -p wa -k time-change"

EXPECTED_OUTPUT_32="-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-
change
-a always,exit -F arch=b32 -S clock_settime -k time-change
-w /etc/localtime -p wa -k time-change"

RULE_FILE="/etc/audit/rules.d/time-change.rules"


AUDITCTL_OUTPUT=$(auditctl -l | grep time-change)
COUNT=0

# checks if the computer is a 65 bit system
if [[ "$VERIFY_RULES"  == "x86_64" ]]; then
    if [[ "$EXPECTED_OUTPUT_64" == "$AUDITCTL_OUTPUT" ]]; then
        echo -e "${GREEN}[+]${RESET} time-change set for Auditd"
        exit 0
    fi
    echo "$EXPECTED_OUTPUT_64" >> $RULE_FILE
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}[+]${RESET} time-change set for Auditd"
        echo -e "${GREEN}[+]${RESET} please restart the daemon"
        exit 0
    else
        echo -e "${RED}[!]${RESET} time-change not set for Auditd"
        exit 1
    fi

else
    if [[ "$EXPECTED_OUTPUT_32" == "$AUDITCTL_OUTPUT" ]]; then
        echo -e "${GREEN}[+]${RESET} time-change set for Auditd"
        exit 0
    fi
    cat "$EXPECTED_OUTPUT_32" >> $RULE_FILE
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}[+]${RESET} time-change set for Auditd"
        echo -e "${GREEN}[+]${RESET} please restart the daemon"
        exit 0
    else
        echo -e "${RED}[!]${RESET} time-change not set for Auditd: Error"
        exit 1
    fi
fi
