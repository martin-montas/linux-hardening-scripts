#!/usr/bin/bash

#                          Auditing/is-auditd-installed.sh
#
#       Rationale:
#           The capturing of system events provides system administrators with 
#           information to allow them to determine if unauthorized access to 
#           their system is occurrin
#


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

# verify if auditd is installed
VERIFY_INSTALLATION=$(dpkg -l | grep auditd)

if [ -z "$VERIFY_INSTALLATION" ]; then
    echo "Auditd is not installed"

    apt install -y auditd audispd-plugins
    INSTALLATION_ERROR=$?

    if [ $INSTALLATION_ERROR -ne 0 ]; then
        echo "Error installing auditd"
        exit 1
    fi

else
    echo "Auditd is installed"
    exit 0
fi
