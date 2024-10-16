#!/usr/bin/bash

#                       auditd-network-env-collection.sh
#                       should be run as root
#                       Author: @martin-montas
#
#                       Rationale:
#       Monitoring sethostname and setdomainname will identify potential unauthorized changes
#       to host and domainname of a system. The changing of these names could potentially break
#       security parameters that are set based on those names. The /etc/hosts file is monitored
#       for changes in the file that can indicate an unauthorized intruder is trying to change
#       machine associations with IP addresses and trick users and processes into connecting to
#       unintended machines. Monitoring /etc/issue and /etc/issue.net is important, as
#       intruders could put disinformation into those files and trick users into providing
#       information to the intruder. Monitoring /etc/network is important as it can show if
#       network interfaces or scripts are being modified in a way that can lead to the machine
#       becoming unavailable or compromised. All audit records will be tagged with the identifier
#       "system-locale."
#

if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit 1
fi
RED='\033[0;31m'
GREEN='\033[0;32m'

RESET='\033[0m'

VERIFY_SYSTEM_LOCALE=$(auditctl -l | grep system-locale) 

VERIFY_RULES=$(uname -m)

EXPECTED_OUTPUT_64="-a always,exit -F arch=b64 -S sethostname,setdomainname -F key=system-locale
-a always,exit -F arch=b32 -S sethostname,setdomainname -F key=system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/network -p wa -k system-locale"


EXPECTED_OUTPUT_32="-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/network -p wa -k system-locale"

if [[ "$VERIFY_RULES"  == "x86_64" ]]; then
    if [[ $VERIFY_SYSTEM_LOCALE != $EXPECTED_OUTPUT_64 ]]; then
        echo "$EXPECTED_OUTPUT_64" >> /etc/audit/rules.d/system-locale.rules
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}[+]${RESET} system-locale set for Auditd"
            echo -e "${GREEN}[+]${RESET} please restart the daemon"
            exit 0
        else
            echo -e "${RED}[!]${RESET} system-locale not set for Auditd" 
            exit 1
        fi

    else
        echo -e "${GREEN}[+]${RESET} system-locale set for Auditd"
        exit 0
    fi

else
    if [[ $VERIFY_SYSTEM_LOCALE != $EXPECTED_OUTPUT_32 ]]; then
        echo "$EXPECTED_OUTPUT_64" >> /etc/audit/rules.d/system-locale.rules
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}[+]${RESET} system-locale set for Auditd"
            echo -e "${GREEN}[+]${RESET} please restart the daemon"
            exit 0
        else
            echo -e "${RED}[!]${RESET} system-locale not set for Auditd"
            exit 1
        fi
    else
        echo -e "${GREEN}[+]${RESET} system-locale set for Auditd"
        exit 0
    fi
fi
