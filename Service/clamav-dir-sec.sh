#!/bin/bash

#                 Service/clamav-dir-sec.sh
#                 should be run as root.
#               
#                 this scripts checks for virus inside important
#                 directories with clamav and saves them in the
#                 clamav_scan.log on the $HOME directory
#

if [[ $(id -u) -ne 0 ]]; then
	echo "Please run as root."
	exit 1
fi
CLAM_LOG="$HOME/clamav_scan.log"

DIR_TO_SCAN=(
	"/bin"
	"/sbin"
	"/usr/bin"
	"/usr/sbin"
	"/tmp"
	"/var/tmp"
	"/etc"
	"/var/log/"
	"/var/lib/"
)

for dir in "${DIR_TO_SCAN[@]}"; do
	clamscan -r $dir --log=$CLAM_LOG
done
