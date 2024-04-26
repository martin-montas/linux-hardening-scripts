#!/bin/bash

# Service/disable-all-bad-serv.sh
# Should run as root.
# This script automates all other scripts that disable services on the repo for ease of use.
# By: martin-montas

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

ARR_OF_SCRIPT=(
        "./Service/ftp-disable.sh"
        "./Service/nfs-disable.sh"
        "./Service/ldap-disable.sh"
        "./Service/samba-disabled.sh"
        "./Service/dhcp-disable.sh"
        "./Service/avahi-disable.sh"
)

for file in "${ARR_OF_SCRIPT[@]}"; do
    bash "$file"
    echo "The exit code of $file script is $?"
done

echo "RAN ALL."
