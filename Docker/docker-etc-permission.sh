#!/bin/bash

#                       Docker/docker-etc-permission.sh
#                       should run as root.
#
#               Rationale:
#               The /etc/docker directory contains certificates and keys in addition to various other
#               sensitive files. It should therefore be individual owned and group owned by root in order
#               to ensure that it can not be modified by less privileged users.
#               
#               by: martin-montas




if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

PATH="/etc/docker"

CHECK_PATH=$(stat -c %U:%G $PATH 2> /dev/null | grep -v root:root 2> /dev/null)

if [[ -z "$CHECK_PATH" ]]; then
    echo "$PATH is owned by the root user."
    exit 0
else
    chown root:root $PATH 2> /dev/null
    echo "$PATH is not owned by the root user and has been changed."
    exit 1
fi

