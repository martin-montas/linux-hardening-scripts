#!/usr/bin/env bash

#                   ./Auditing/auditd-logs-not-deleted.sh
#                   should be run as root
#                   Author: @martin-montas
#
#       Rationale:
#           In high security contexts, the benefits of maintaining a long 
#           audit history exceed the cost of storing the audit history.
#

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

RED='\033[0;31m'
GREEN='\033[0;32m'

RESET='\033[0m'

#   space_left_action = email
#   action_mail_acct = root
#   admin_space_left_action = halt


SPACE_LEFT_ACTION=$(grep -P 'space_left_action = email' /etc/audit/auditd.conf)
ACTION_MAIL_ACCT=$(grep -P 'action_mail_acct = root' /etc/audit/auditd.conf)
ADMIN_SPACE_LEFT_ACTION=$(grep -P 'admin_space_left_action = halt' /etc/audit/auditd.conf)

COUNT=0


if [[ -z "$SPACE_LEFT_ACTION" ]]; then
    echo 'space_left_action = email' >> /etc/audit/auditd.conf
    echo -e "${GREEN}[+]${RESET} Space left action set to email for Auditd"
    count=$((COUNT+1))
fi
 
if [[ -z "$ACTION_MAIL_ACCT" ]]; then
    echo 'action_mail_acct = root' >> /etc/audit/auditd.conf
    echo -e "${GREEN}[+]${RESET} action_mail_acct set to email for Auditd"
    count=$((COUNT+1))

fi

if [[ -z "$ADMIN_SPACE_LEFT_ACTION" ]]; then
    echo 'admin_space_left_action = halt' >> /etc/audit/auditd.conf
    echo -e "${GREEN}[+]${RESET} admin_space_left_action set to email for Auditd"
    count=$((COUNT+1))
fi

if [ "$COUNT" -eq 3 ]; then
    echo -e "${GREEN}[+]${RESET} All the required parameters were set for auditd"
    exit 0
else
    echo -e "${RED}[!]${RESET} Not all the required parameters were set for auditd"
    exit 1
fi




