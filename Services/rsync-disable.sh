#!/bin/bash

#                       Service/rsync.disable.sh
#                       should be run as root.
#
#                       Rationale:
#                       The rsync service presents a security risk as it uses unencrypted protocols for
#                       communication. The rsync package should be removed to reduce the attack area of the
#                       system.


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE="rsync"
INSTALLED=$(dpkg -l | awk  '$2 == "rsync" {print $1}' | grep '^ii') 

if [[ -n $INSTALLED ]]; then
    yes | apt  purge $SERVICE  >  /dev/null
else
    echo "$SERVICE was not installed."
fi

