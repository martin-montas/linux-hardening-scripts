#!/usr/bin/bash

#                    Service/remove-old-pack.sh
#                    should be run as root
#                    Author: @eto330
#
#




if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi


old_packages=$(dpkg -l | grep -P '^rc'  | awk '{print $2}')


for package in $old_packages; do
  if [[ -n "$package" ]]; then  
    echo "Removing package: $package"
    dpkg --purge "$package" || echo "Error removing $package. Skipping..."
  fi
done

if [[ -z "$old_packages" ]]; then
  echo "No old packages found."
  exit 
fi


