#!/bin/bash

#                      Docker/docker-secure-registry.sh
#                           should run as root
#                           by: martin-montas
#
#   Rationale:
#      A secure registry uses TLS. A copy of registry's CA certificate is placed on the Docker
#      host at /etc/docker/certs.d/<registry-name>/ directory. An insecure registry is one
#      which does not have a valid registry certificate, or one not using TLS. Insecure registries
#      should not be used as they present a risk of traffic interception and modification.
#      Additionally, once a registry has been marked as insecure commands such as docker
#      pull, docker push, and docker search will not result in an error message and users
#      may indefinitely be working with this type of insecure registry without ever being notified
#      of the risk of potential compromise.



DOCKER_FILE="/etc/docker/daemon.json"
DOCKER_USER='bob'

# Check if insecure registries are configured
INSECURE_REGISTRIES=$(docker info --format '{{.RegistryConfig.InsecureRegistryCIDRs}}' | wc -l)
DEFAULT_SHELL=$(getent passwd "$DOCKER_USER" | cut -d: -f7)

if [[ "$INSECURE_REGISTRIES" -gt 1 ]]; then

        jq -r '. + {"insecure-registries": []}' "$DOCKER_FILE" > "$DOCKER_FILE.tmp" && mv "$DOCKER_FILE.tmp" "$DOCKER_FILE"
        if grep -q 'zsh' <<< "$DEFAULT_SHELL"; then
            echo 'export DOCKER_CONTENT_TRUST=1' >> "/home/$DOCKER_USER/.zshrc"
        elif grep -q 'bash' <<< "$DEFAULT_SHELL"; then
            echo 'export DOCKER_CONTENT_TRUST=1' >> "/home/$DOCKER_USER/.bashrc"
        fi

        echo "Restarting the docker daemon..."
        systemctl restart docker
else
    echo "All the Docker registries are all good."
fi

