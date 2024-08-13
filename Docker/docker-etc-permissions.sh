#!/usr/bin/bash

#                       Docker/docker-etc-permissions.sh

#       Rationale:
#            The /etc/docker directory contains certificates and keys in addition to various sensitive
#            files. It should therefore only be writeable by root to ensure that it can not be modified
#            by a less privileged user
#
#            by: martin-montas

if [[ $(id -u) -ne 0 ]]; then
    echo "Please run as root."
    exit 1
fi

DOCKER_PATH="/etc/docker"

CHECK_PATH_PERM=$(stat -c %a $DOCKER_PATH 2> /dev/null | grep -v 755 2> /dev/null)


if [[ -z "$CHECK_PATH_PERM" ]]; then
    echo "$DOCKER_PATH has good permissions."
    exit 0
else
    chmod 755 $DOCKER_PATH 2> /dev/null
    echo "$DOCKER_PATH is not writeable by the root user and has been changed."
    exit 1
fi
