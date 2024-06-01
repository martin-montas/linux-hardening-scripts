#!/bin/bash
#                       Docker/docker-socket-file-ownership.sh
#                               should be run as root.
#       Rationale:
#           The docker.socket file contains sensitive parameters that may alter the behavior of the
#           Docker remote API. For this reason, it should be owned and group owned by root in
#           order to ensure that it is not modified by less privileged users.
#
#


# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi
RED='\033[0;31m'
GREEN='\033[0;32m'

RESET='\033[0m'


SOCKET_FILE=$(systemctl show -p FragmentPath docker.socket | cut -d '=' -f 2)
if [ -f "$SOCKET_FILE" ]; then
    chown root:root "$SOCKET_FILE"
    chmod 644 "$SOCKET_FILE"
    echo -e "${GREEN}[+]${RESET} The docker.socket file is owned and group owned by root."
else
    echo -e "${RED}[-]${RESET} The docker.socket does not exist."
fi

