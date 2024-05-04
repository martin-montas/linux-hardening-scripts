#!/bin/bash


#                   Docker/docker-iptables-changes.sh
#                   should run as root. 
#                   by: martin-montas
#
#    Rationale:
#  Docker will never make changes to your system iptables rules unless you allow it to
#  do so. If you do allow this, Docker server will automatically make any required changes.
#  We recommended letting Docker make changes to iptables automatically in order to
#  avoid networking misconfigurations that could affect the communication between
#  containers and with the outside world. Additionally, this reduces the administrative
#  overhead of updating iptables every time you add containers or modify networking
#  options.
#
#    What it does:
#  This script works by setting finding if the dockerd has iptables set to false. If it finds
#  it, sets it without the parameters which puts it in default.
#
#

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root."
  exit 1
fi

if ps -ef | grep dockerd | grep 'iptables'; then

    echo  "setting the docker daemon with --iptables..."
    systemctl --user restart dockerd
else

    echo "the daemon is already good."
fi

