#!bin/bash


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi



IS_EMPTY=$(sudo awk -F: '($2 == "") {print $1}' /etc/shadow)

if [[ -z "$IS_EMPTY" ]]; then

    echo "There is an empty password on the /etc/shadow file."
    exit 1
else
    echo "Everything is good."
    exit 0
fi











