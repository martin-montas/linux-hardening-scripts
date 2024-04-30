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
#
#       this script creates a non icc (inter-connected container
#


# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi

icc_net_kernel_mod() {
    MODULE_EXISTENCE=$(ls /lib/modules/"$(uname -r)"/kernel/net/bridge/br_netfilter.ko)
    MODULE_SET=$(lsmod  | grep br_netfilter)
    
    # Checks if the kernel module not set 
    if [ -z "$MODULE_SET" ]; then

        # If the kernel module exists
        if [ -n "$MODULE_EXISTENCE" ]; then
            sudo modprobe br_netfilter
            sudo sh -c 'echo "br_netfilter" > /etc/modules-load.d/br_netfilter.conf'
            return 
        else
            :
        fi
    fi
    # If the kernel module is not set
    if [ -n "$MODULE_SET" ]; then
        echo "The module is already set..."
        return
    fi

}
# Function to create a custom bridge network for segregated containers
create_custom_network() {
    DOCKERUSER='bob'
    NETWORK_NAME="non-icc-net"
    if ! docker network inspect "$NETWORK_NAME" &>/dev/null; then
        
    su -l "$DOCKERUSER" -c 'systemctl --user start docker'
        su -l "$DOCKERUSER" -c "
        docker network create --driver bridge -o 'com.docker.network.bridge.enable_icc'='false' '$NETWORK_NAME'
        "
        echo "Custom network '$NETWORK_NAME' created for segregated containers."
    else
        echo "Custom network '$NETWORK_NAME' already exists. Skipping network creation."
    fi
}

# Main function
main() {

    # Ensure that the network can be set
    icc_net_kernel_mod

    # Creates the network 
    create_custom_network
}

# Call the main function
main
