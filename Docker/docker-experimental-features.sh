#!/bin/bash

#                           Docker/docker-exprimental-features.sh
#           Description:
#               Experimental features should not be enabled in production.
#           Rationale:
#               "Experimental" is currently a runtime Docker daemon flag rather than being a feature of
#               a separate build. Passing --experimental as a runtime flag to the docker daemon
#               activates experimental features. Whilst "Experimental" is considered a stable release, it
#               has a number of features which may not have been fully tested and do not guarantee
#               API stability.

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'

RESET='\033[0m'

if  docker version --format '{{ .Server.Experimental }}' | grep -q true; then
    echo -e "${RED}[!]${RESET} Docker daemon is running in experimental mode."
    echo -e "${RED}[!]${RESET} Please make sure that docker daemon is not run with the --experimental flag."
else
    echo -e "${GREEN}[+]${RESET} Docker daemon is not running in experimental mode."
fi
