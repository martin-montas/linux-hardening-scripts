#!/bin/bash


#                    Service/ssh-service-harden.sh
#                    should be run as root
#                    Author: @eto330
#
#                    this script adds config variables to the sshd.service unit file
#


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE_NAME="sshd.service"
DROPIN_DIR="/etc/systemd/system/${SERVICE_NAME}.d"
CONFIG_FILE="${DROPIN_DIR}/security.conf"


mkdir -p "${DROPIN_DIR}"
touch "${CONFIG_FILE}"

# these are the config fot the ssh  unit file
tee "${CONFIG_FILE}" <<EOF
[Service]
User=root
Group=root
UsePrivilegeSeparation=yes
PermitRootLogin=no
UsePAM=yes
EOF

systemctl daemon-reload
systemctl restart  ${SERVICE_NAME}


