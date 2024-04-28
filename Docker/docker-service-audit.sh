#!/bin/bash

#                       Docker/docker-service-audit.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to CIS 
#               Benchmark. Rationale:
#
#       As well as auditing the normal Linux file system and system calls, you should also audit
#       all Docker related files and directories. The Docker daemon runs with root privileges
#       and its behavior depends on some key files and directories with docker.service being
#       one such file. The docker.service file might be present if the daemon parameters have
#       been changed by an administrator. If so, it holds various parameters for the Docker
#       daemon and should be audited.

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root."
  exit 1
fi

FILE_EXIST=$(systemctl show -p FragmentPath docker.service)

if [[ -z $FILE_EXIST ]]; then

    # Check if Docker service is being audited
    if ! auditctl -l | grep -q docker.service;  then

    # Adds the proper Docker rule to Auditd:
    echo "-w /usr/lib/systemd/system/docker.service -k docker" >> /etc/audit/rules.d/audit.rules
    echo "Docker daemon auditing rule added."

    # restarts the audit daemon to enforce the rule:
    systemctl restart auditd
    else
        echo "Docker daemon is already being audited."
    fi
fi

