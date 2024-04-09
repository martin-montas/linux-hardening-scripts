#!/usr/bin/bash

#                    File/umask-login.sh
#                    should be run as root  
#                    Author: @eto330
#
# This script should be run as root. If not, it will exit.
if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi

FILE=/etc/login.defs
sed -i 's/^UMASK.*/UMASK 027/' $FILE

echo "UMASK set to 027"


