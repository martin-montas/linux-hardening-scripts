#!/bin/bash

#                       Docker/dockerd-audit.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to CIS 
#               Benchmark. Rationale:
#
#           As well as auditing the normal Linux file system and system calls, 
#           you should also audit the Docker daemon. Because this daemon runs 
#           with root privileges. It is very important to audit its activities 
#           and usage.

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root."
  exit 1
fi

# Check if Docker daemon is being audited
if ! auditctl -l | grep -q "/usr/bin/dockerd"; then

    # Adds the proper Docker rule to Auditd:
    echo "-w /usr/bin/dockerd -k docker" >> /etc/audit/rules.d/audit.rules
    echo "Docker daemon auditing rule added."

    # restarts the audit daemon to enforce the rule:
    systemctl restart auditd
else

    echo "Docker daemon is already being audited."
fi
