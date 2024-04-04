#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

VAR_SET=()

check_for_package() {

    # checks is a  desktop enviroment exist
    SEARCH_FOR_PACKAGE=dpkg -l | grep -E 'ubuntu-desktop|kubuntu-desktop|xubuntu-desktop|gnome-desktop'
    if [[ -n "$SEARCH_FOR_PACKAGE" ]]; then
        VAR_SET+=("desktop found!")
    fi

    SEARCH_FOR_RDP_INSTALLED=dpkg -l | grep xrdp
    if [[ -n "$SEARCH_FOR_RDP_INSTALLED" ]]; then
        VAR_SET+=("RDP found!")
    fi

}
check_for_package

if [[ -n "$VAR_SET" ]]; then
    echo "Nothing was found"
    exit 0
fi
# Iterate over each element in the array
for element in "${check_for_package[@]}"; do
    echo "Attention: $element"
    exit 1
done
