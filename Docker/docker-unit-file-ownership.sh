#!/bin/bash

#                   Docker/docker-unit-file-ownership.sh
#                           should be run as root
#
#       Rationale:
#           This script ensures that the Docker unit file is owned by the root user
#           The docker.service file contains sensitive parameters that may alter the behavior of the
#           Docker daemon. It should therefore be individually and group owned by the root user in
#           order to ensure that it is not modified or corrupted by a less privileged user.
#
#           this script is only applicable for non rootless mode.


# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi

GREEN='\033[0;32m'
BLUE='\033[0;34m'

RESET='\033[0m'

AUDIT=$(systemctl show -p FragmentPath docker.service | grep FragmentPath)

# verify the binary exists
if [ -n "$AUDIT" ]; then

    # gets the full path of the specify in the audit command 
    FULL_PATH=$(grep -v "FragmentPath=" "$AUDIT" 2> /dev/null)
    if stat -c %U:%G "$FULL_PATH" | grep -v root:root 2> /dev/null; then
        chown root:root "$FULL_PATH" 2> /dev/null
        echo -e "${GREEN}[+]${RESET} The file $FULL_PATH is now owned by root."
        exit 0
    else
        echo -e "${BLUE}[*]${RESET} The file $FULL_PATH is already owned by root."
        exit 1
    fi
else
    echo -e "${BLUE}[*]${RESET} The docker.service file does not exist."
    exit 1

fi
