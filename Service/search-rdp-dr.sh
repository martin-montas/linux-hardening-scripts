#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

VAR_SET=()

check_for_package() {

    # checks is a  desktop enviroment exist
    SEARCH_FOR_PACKAGE=$(dpkg -l | grep -E 'ubuntu-desktop|kubuntu-desktop|xubuntu-desktop|gnome-desktop')
    if [[ -n "$SEARCH_FOR_PACKAGE" ]]; then
        #echo $SEARCH_FOR_PACKAGE
        VAR_SET+=("desktop found!")
    fi

    # checks is RDP is installed
    SEARCH_FOR_RDP_INSTALLED=$(dpkg -l | grep xrdp)
    if [[ -n "$SEARCH_FOR_RDP_INSTALLED" ]]; then
        #echo $SEARCH_FOR_RDP_INSTALLED
        VAR_SET+=("RDP found!")
    fi

}
check_for_package

if [[ ${#VAR_SET[@]} -eq 0 ]]; then
    echo  "Nothing was found"
    exit 1
fi
# Iterate over each element in the array
for element in "${VAR_SET[@]}"; do
    echo  "Attention: $element"
done
