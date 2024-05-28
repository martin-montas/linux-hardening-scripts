#!/bin/bash

#                           Docker/docker-namespace-support.sh
#
#       Rationale:
#         The Linux kernel "user namespace" support within the Docker daemon provides
#         additional security for the Docker host system. It allows a container to have a unique
#         range of user and group IDs which are outside the traditional user and group range
#         utilized by the host system.
#         For example, the root user can have the expected administrative privileges inside the
#         container but can effectively be mapped to an unprivileged UID on the host system.
#
#         This script adds the --no-new-privileges option to the ExecStart line in the
#         Docker systemd unit file for rootless mode.
#
#         This script is only applicable to the default docker daemond  mode since no-new-privileges 
#         is enabled by default in the rootless mode.
#         



# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi

# The current docker user that runs the root-less dockerd daemon
DOCKER_FILE="/etc/docker/daemon.json"

# Check if Docker daemon is already configured for rootless mode
if ps -ef | grep dockerd | grep "no-new-privileges" >/dev/null 2>&1; then
    echo "[*] Docker daemon is already configured for rootless mode."
    exit 0
fi

# JSON data to add or modify
new_data='"no-new-privileges": true'

# Change the permissions of the file
chmod 744 "$DOCKER_FILE"

# Check if daemon.json exists, if not, create it with new_data
if [ ! -f "$DOCKER_FILE" ]; then
    echo "{$new_data}" > "$DOCKER_FILE"
else
    # Check if new_data is already present
    if ! grep -q "$new_data" "$DOCKER_FILE"; then
        if [ -s "$DOCKER_FILE" ]; then
            # Remove the trailing brace and add new_data
            sed -i '$ s/}$//; $a ,\n  '"$new_data"'\n}' "$DOCKER_FILE"
        else
            echo "{$new_data}" > "$DOCKER_FILE"
        fi
    else
        echo "[*] The no-new-privileges option is already present."
    fi
fi

# Restart Docker daemon
systemctl restart docker
echo "[+] The Docker daemon is now configured with no new privileges."
exit 0
