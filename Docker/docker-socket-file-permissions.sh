#!/usr/bin/bash


#                       Docker/docker-socket-file-permisions.sh
#                               should be run as root.
#       Rationale:
#     The docker.socket file contains sensitive parameters that may alter the behavior of the
#     Docker remote API. It should therefore be writeable only by root in order to ensure that
#     it is not modified by less privileged users.


# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi

DOCKER_SOCKET_FILE_LOCATION=$(systemctl show -p FragmentPath docker.socket | cut -d '=' -f 2)

if [ -f "$DOCKER_SOCKET_FILE_LOCATION" ]; then

    chmod 644 "$DOCKER_SOCKET_FILE_LOCATION" 2> /dev/null
    echo "The docker.socket file is now writeable only by root."
    exit 0
else
    echo "The docker.socket file does not exist."
    exit 1
fi
