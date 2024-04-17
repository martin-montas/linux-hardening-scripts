#!/usr/bin/bash


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi


main() {
    clear
    echo "===================================="
    echo "*  users with root priviledge are: *"
    echo "*                                  *"
    echo "+----------------------------------+"
    awk -F: '($3 == 0) {print $1}' /etc/passwd 

    echo "===================================="
    echo "*    sudoers privilege users are:  *"
    echo "*                                  *"
    echo "+----------------------------------+"
    sudo  -l

    echo "===================================="
    echo "*current users and their group are *"
    echo "*                                  *"
    echo "+----------------------------------+"
    getent passwd | awk -F: '{print $1,$4}'

}



main
