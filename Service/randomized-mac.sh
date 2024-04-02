#!/usr/bin/bash

#      This Bash script creates a file for the NetworkManager folder that randomizes 
#      the MAC address of your system for harder identification. Remember that this script 
#      only depends of firmware support for the interface that are supported for this action.
#
#       should be run as sudo.
#


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Path to the file 
FILE_PATH="/etc/NetworkManager/conf.d/99-random-mac.conf"

configuration="
[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
"

#   creates the file
touch       $FILE_PATH

#   sets the  file permissions
chmod 644   $FILE_PATH

echo "$configuration" >> $FILE_PATH

systemctl restart NetworkManager
