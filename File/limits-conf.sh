#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
	echo "Please run as root."
	exit 1
fi


LIMITS_CONF="/etc/security/limits.conf"

tee "${LIMITS_CONF}" <<EOF

*       soft    nproc   100
*       hard    nproc   200

*       soft    nofile   1000
*       hard    nofile   2000

*       soft    rss     1000000   # 1000 MB
*       hard    rss     2000000   # 2000 MB

*       soft    cpu     2000     # 2000 seconds
*       hard    cpu     3000     # 3000 seconds


*       hard    core    0
EOF


# ask to reboot the system
echo "Done. Please reboot."
