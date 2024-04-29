#!/bin/bash

#                   Docker/docker-network-restriction.sh
#
#                   should run as root.
#   Rationale:
#
#       By default, unrestricted network traffic is enabled between 
#       all containers on the same host on the default network bridge. 
#       Thus, each container has the potential of reading all packets 
#       across the container network on the same host. This might lead 
#       to an unintended and unwanted disclosure of information to other 
#       containers. Hence, restrict inter-container communication on the 
#       default network bridge.



# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi

DOCKERUSER='bob'
DAEMON_FILE="/etc/docker/daemon.json"

# Function to check if the file exists and create it if not
check_file_exist() {
    if [ ! -f "$DAEMON_FILE" ]; then
        touch "$DAEMON_FILE"
    fi
}

# Function to insert configuration to the file if not already enabled
insert_to_the_file() {
    if [ -n "$NOT_ENABLED" ]; then
        echo "Adding to the $DAEMON_FILE..."
        # Remove any existing icc setting if present
        sed -i '/"icc":/d' "$DAEMON_FILE"
        # Append the new icc setting
        echo '{ "icc": false }' >> "$DAEMON_FILE"
        # Restart Docker daemon
        systemctl restart docker
        echo "Restarted the Docker daemon"
        exit 0
    else
        echo "The configuration is already set."
        exit 0
    fi
}

# Main function
main() {
    NOT_ENABLED=$(su -l "$DOCKERUSER" bash -c 'docker network ls --quiet | xargs docker network inspect --format '\''{{ .Name }}: {{ .Options }}'\'' | grep true')
    check_file_exist
    insert_to_the_file
}

# Call the main function
main
