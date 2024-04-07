#!/usr/bin/bash

#       cron-permission.sh is a Bash script that changes the permissions of cron files.
#       It should be run as root.
#
#       Author: @eto330


# Check if the script is being run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

declare -a cron
cron=(
'chown root:root /etc/anacrontab'
'chmod og-rwx /etc/anacrontab'
'chown root:root /etc/crontab'
'chmod og-rwx /etc/crontab'
'chown root:root /etc/cron.hourly'
'chmod og-rwx /etc/cron.hourly'
'chown root:root /etc/cron.daily'
'chmod og-rwx /etc/cron.daily'
'chown root:root /etc/cron.weekly'
'chmod og-rwx /etc/cron.weekly'
'chown root:root /etc/cron.monthly'
'chmod og-rwx /etc/cron.monthly'
'chown root:root /etc/cron.d'
'chmod og-rwx /etc/cron.d'
)
declare -a cron2

cron2=(
'chmod 644 /etc/passwd'
'chown root:root /etc/passwd'
'chmod 644 /etc/group'
'chown root:root /etc/group'
'chmod 600 /etc/shadow'
'chown root:root /etc/shadow'
'chown root:root /etc/gshadow'

)

for cmd in "${cron2[@]}"; do
    echo "Executing command of cron2: $cmd"
    eval "$cmd"
    echo "------------------------------------"
done

for cmd in "${cron[@]}"; do
    echo "Executing command of cron: $cmd"
    eval "$cmd"
    echo "------------------------------------"
done
echo "All commands executed successfully."
exit 0
