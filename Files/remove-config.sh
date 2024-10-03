#!/usr/bin/bash

# Get list of packages to purge
packages=$(dpkg -l | awk '/^rc/ { print $2 }')

# Purge each package
for package in $packages; do
    sudo dpkg --purge $package
done
