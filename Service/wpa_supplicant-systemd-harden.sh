#!/bin/bash


#                    Service/wpa_supplicant-service-harden.sh
#                    should be run as root
#                    Author: @eto330
#
#                    this script adds config variables to the wpa_supplicant.service unit file
#


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SERVICE_NAME="wpa_supplicant.service"
DROPIN_DIR="/etc/systemd/system/${SERVICE_NAME}.d"
CONFIG_FILE="${DROPIN_DIR}/security.conf"


mkdir -p "${DROPIN_DIR}"
touch "${CONFIG_FILE}"

tee "${CONFIG_FILE}" <<EOF
[Service]
# Restrict capabilities
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE

# Set restrictive file system access
ProtectSystem=full
ProtectHome=yes
NoNewPrivileges=yes
ReadWritePaths=/etc/wpa_supplicant
EOF

systemctl daemon-reload
systemctl restart  ${SERVICE_NAME}


