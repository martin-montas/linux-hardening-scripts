#!/us/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi



NEWRULE="-w /var/run/sudo/sudo.log -p wa -k privileged"
RULE_FILE="/etc/audit/rules/d/sudo_usage.rules"

# Create the file (if it doesn't exist) and append content
echo "$NEWRULE" >> $RULE_FILE
echo "The  Auditd rule has been set."
