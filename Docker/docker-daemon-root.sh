#!/usr/bin/env bash

#                   Docker/docker-daemon-root.sh
#                   should run as root.
#
#   Rationale:
#       Rootless mode allows running the Docker daemon and containers as a non-root user to
#       mitigate potential vulnerabilities in the daemon and the container runtime.
#
#       This script was refactored with the help of Chatgpt
#


# Define variables
DOCKERUSER='bob'
DOCKER_REPO="https://download.docker.com/linux/ubuntu"
DOCKER_GPG_KEY="$DOCKER_REPO/gpg"

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi

# Install required packages
apt_update() {
    echo "Updating package index..."
    apt update
}

install_dependencies() {
    echo "Installing dependencies..."
    apt install -y apt-transport-https ca-certificates curl software-properties-common uidmap
}

# Add Docker repository and install Docker
install_docker() {
    echo "Adding Docker repository..."
    curl -fsSL $DOCKER_GPG_KEY | apt-key add -
    add-apt-repository "deb [arch=amd64] $DOCKER_REPO focal stable"
    apt_update

    echo "Installing Docker..."
    apt install -y docker-ce
}

# Configure Docker for rootless mode
configure_docker_rootless() {
    echo "Configuring Docker for rootless mode..."
    su -l $DOCKERUSER -c 'curl -fsSL https://get.docker.com/rootless | sh'

    echo "export PATH=/home/$USER/bin:$PATH" >> "$HOME/.bashrc"
    echo 'export DOCKER_HOST=unix:///run/user/1000/docker.sock' >> "$HOME/.bashrc"
}

# Disable and enable Docker services
manage_docker_services() {
    echo "Disabling Docker service and socket..."
    systemctl disable --now docker.service docker.socket

    echo "Enabling Docker service for user $DOCKERUSER..."
    su -l $DOCKERUSER -c 'systemctl --user start docker'
    su -l $DOCKERUSER -c 'systemctl --user enable docker'
}

# Enable user to linger and adjust kernel settings
configure_system() {
    echo "Configuring system settings..."
    loginctl enable-linger $DOCKERUSER
    echo 'net.ipv4.ip_unprivileged_port_start=0' >> /etc/sysctl.conf
    echo 'kernel.unprivileged_userns_clone=1' >> /etc/sysctl.conf
    sysctl --system
}

# Prompt for reboot
prompt_reboot() {
    read -r -p "System configuration requires a reboot. Reboot now? [Y/n] " response
    if [[ $response =~ ^([yY][eE][sS]|[yY]|)$ ]]; then
        echo "Rebooting system..."
        reboot
    else
        echo "Please remember to reboot your system later."
    fi
}

# Main function
main() {
    install_dependencies
    install_docker
    configure_docker_rootless
    manage_docker_services
    configure_system
    prompt_reboot
}

# Execute main function
main
