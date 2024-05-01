#!/bin/bash

#                   Docker/docker-logging-info.sh
#                   should run a root
#                   by: martin-montas
#
#   Rationale:
#       Setting up an appropriate log level, configures the Docker daemon to log events that
#       you would want to review later. A base log level of info and above would capture all
#       logs except debug logs. Until and unless required, you should not run Docker daemon
#       at debug log level.
#
#   What it does:
#       This script checks if the log level is set. If it isn't , it sets it thru the 
#       "daemon.json" file located in "/etc/docker/" then it restarts the dockerd daemon.



# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi

if ps -ef | pgrep dockerd | grep "log-level"; then

    EXISTING_JSON=$(cat /etc/docker/daemon.json 2>/dev/null || echo "{}")

    # "log-level": "info"
    MODIFIED_JSON=$(echo "$EXISTING_JSON" | jq '. + {"log-level": "info"}')

    # Step 3: Write modified JSON back to daemon.json
    echo "$MODIFIED_JSON" | tee /etc/docker/daemon.json >/dev/null

    # restarts the dockerd daemon
    systemctl --user restart dockerd

else
    echo "Log level is already set to default (info)."
fi


