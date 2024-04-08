#!/usr/bin/bash

#           process-users.sh is a Bash script that adds a private process to /etc/fstab
#           It should be run as root.
#
#           by adding the private process to /etc/fstab and then remounting /proc
#           you make sure you can not access /proc from any other user and prevents
#           other users access to your private process.
#
#           Author: @eto330



if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

FSTAB='/etc/fstab'
PRIVATE_PROCESS='proc    /proc   proc    hidepid=2       0 0'


if grep -Fxq "$PRIVATE_PROCESS" "$FSTAB"
then
    echo "Private process already in fstab"
else
    echo "Adding private process to fstab"
    echo "$PRIVATE_PROCESS" >> "$FSTAB"
    mount -o remount proc
fi

echo "Private process added to fstab"
