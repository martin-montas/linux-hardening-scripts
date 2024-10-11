#!/usr/bin/bash


#                ./Auditing/auditd-user-group-info-collection.sh
#                should be run as root
#                Author: @martin-montas
#
#       Rationale:
#
#       Unexpected changes to these files could be an indication that the 
#       system has been compromised. The system could be compromised and that 
#       an unauthorized user is attempting to hide their activities or
#       compromise additional accounts.


if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi

RED='\033[0;31m'
GREEN='\033[0;32m'

RESET='\033[0m'

RULE_FILE="/etc/audit/rules.d/identity.rules"

 
EXPECTED_OUTPUT="-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity
"

VERIFICATION=$(auditctl -l | grep identity)


if [[ "$VERIFICATION" == "$EXPECTED_OUTPUT" ]]; then
    echo -e "${GREEN}[+]${RESET} All the required parameters were set for auditd"
    exit 0
else # Remediation:
    echo "$EXPECTED_OUTPUT" > $RULE_FILE

    if [[ $? -ne 0 ]]; then
        echo -e "${RED}[!]${RESET} Not all the required parameters were set for auditd"
        exit 1
    else
        echo -e "${GREEN}[+]${RESET} All the required parameters were set for auditd"
        exit 0
    fi
fi


