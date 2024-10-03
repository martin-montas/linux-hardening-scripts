#!/usr/bin/bash

#                           Service/docker-sec.sh
#                           should be run as root
#
#                           Author: @eto330
#
#                           this script adds config variables to the docker daemon unit file
#                           and to the .zshrc file
#

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

SHELL_FILE="/home/bob/zshrc"
DOCKER_OPTION_FILE="/etc/docker/daemon.json"


# append to the .zshrc file
echo "export DOCKER_CONTENT_TRUST=1" >> ${SHELL_FILE}

# creates the docker option file 
touch "${DOCKER_OPTION_FILE}"

# append to the docker option file
tee "${DOCKER_OPTION_FILE}" <<EOF
{
  "log-level": "info",
  "iptables": true,
  "userland-proxy": false,
  "no-new-privileges": true,
  "default-ulimits": {
    "nofile": {
      "Soft": 1024,
      "Hard": 2048
    },
    "nproc": {
      "Soft": 512,
      "Hard": 1024
    }
  },
  "userns-remap": "default",
  "live-restore": true,
  "storage-driver": "overlay2",
  "max-concurrent-downloads": 5,
  "max-concurrent-uploads": 5,
  "max-download-attempts": 3,
  "insecure-registries": [],
  "registry-mirrors": [],
  "exec-opts": [
    "native.cgroupdriver=systemd"
  ],
  "features": {
    "buildkit": true
  }
}


EOF

# restarts docker 
systemctl restart docker
