#!/usr/bin/bash


#                   /Service/cron-user-display.sh
#                   should be run as r00t  
#                   by:  martin-montas
#
#                   this script goes thru the /etc/passwd file and finds
#                   each uid of non system users then gets their password
#                   and finds all the crontab for each of them.
#


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

#  iterates thru the uid
for uid in $(awk -F: '$3 >= 1000 {print $3}' /etc/passwd)
do
    # gets  the passwd thru the uid 
    USERNAME=$(getent passwd "$uid" | cut -d: -f1)

    # finds the crontab based on the USERNAME 
    echo "Crontab for user $USERNAME (UID: $uid):"
    crontab -u "$USERNAME" -l 2>/dev/null  
    echo "---------------------------"
done
