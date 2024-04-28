#!/bin/bash

#                           Docker/docker-daemon-root.sh
#                           should run as root.
#
#           Rootless mode allows running the Docker daemon and containers 
#           as a non-root user to mitigate potential vulnerabilities in 
#           the daemon and the container runtime.
#



# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

# Check if docker is installed
if which docker >/dev/null 2>&1; then
    # Stop Docker service if running
    if systemctl is-active --quiet docker; then
        systemctl stop docker
    fi

    # Remove Docker packages
    apt remove --yes docker docker-engine docker.io containerd runc || {
        echo "Error: Failed to remove Docker packages."
        exit 1
    }

    # Install Docker in rootless mode
    curl -fsSL https://get.docker.com/rootless | sh

    # Start Docker service for the current user
    systemctl --user start docker

    # Set up environment variables
    DOCKER_USER="$USER"
    DOCKER_HOME="$(eval echo ~"$DOCKER_USER")"
    DOCKER_BIN="$DOCKER_HOME/bin"

    echo "export PATH=$DOCKER_BIN:\$PATH" >> "$DOCKER_HOME"/.bashrc
    echo "export DOCKER_HOST=unix://\$XDG_RUNTIME_DIR/docker.sock" >> "$DOCKER_HOME"/.bashrc

    echo "To enable/disable Docker daemon and use the --user command."
    exit 0
else
    # Install Docker in rootless mode
    curl -fsSL https://get.docker.com/rootless | sh

    # Start Docker service for the current user
    systemctl --user start docker

    # Set up environment variables
    DOCKER_USER="$USER"
    DOCKER_HOME="$(eval echo ~"$DOCKER_USER")"
    DOCKER_BIN="$DOCKER_HOME/bin"

    echo "export PATH=$DOCKER_BIN:\$PATH" >> "$DOCKER_HOME"/.bashrc
    echo "export DOCKER_HOST=unix://\$XDG_RUNTIME_DIR/docker.sock" >> "$DOCKER_HOME"/.bashrc

    echo "To enable/disable Docker daemon and use the --user command."
    exit 0
fi

