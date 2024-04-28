#!/bin/bash

#                       Docker/containerd-audit.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to CIS 
#               Benchmark. Rationale:
#
#           As well as auditing the normal Linux file system and system calls, you should also audit
#           all Docker related files and directories. The Docker daemon runs with root privileges
#           and its behaviour depends on some key files and directories. /run/containerd is one
#           such directory. As it holds all the information about containers it should be audited.


# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root."
  exit 1
fi

# Check if Docker daemon is being audited
if ! auditctl -l | grep -q /run/containerd;  then

    # Adds the proper Docker rule to Auditd:
    echo "-a exit,always -F path=/run/containerd -F perm=war -k docker" >> /etc/audit/rules.d/audit.rules

    echo "Docker daemon auditing rule added."

    # restarts the audit daemon to enforce the rule:
    systemctl restart auditd
else
    echo "Docker daemon is already being audited."
fi
