#!/usr/bin/bash

#           WHAT IT DOES:
#
#           This Bash script appends a group of parameters to the sshd_config file on /etc/ssh/
#           . It prevents obvious like empty passwords permitting root logins and more. It should
#           be run as root. The parsing of the file is done with  sed.
#



if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


LOG_FILE="/etc/ssh/sshd_config"


# Define variables
PERMIT_EMPTY_PASS="#PermitEmptyPasswords no"
PERMIT_EMPTY_PASS_NEW="PErmitEmptyPasswords no"

PERMIT_ROOT_LOGIN="#PermitRootLogin no"
PERMIT_ROOT_LOGIN_NEW="PErmitRootLogin no"

CLIENT_ALIVE_INTERVAL="#ClientAliveInterval 0"
CLIENT_ALIVE_INTERVAL_NEW="ClientAliveInterval 60"

CLIENT_ALIVE_COUNTMAX="#ClientAliveCountMax 3"
CLIENT_ALIVE_COUNTMAX_NEW="ClientAliveCountMax 3"

# Define a function that takes parameters
adds_to_sshd_config() {
    local old_entry=$1
    local new_entry=$2
    local file=$3

    sed -i "s/$old_entry/$new_entry/g" "$file"
}


# Call the function and pass variables to it
adds_to_sshd_config "$PERMIT_EMPTY_PASS"  "$PERMIT_EMPTY_PASS_NEW" "$LOG_FILE"
adds_to_sshd_config "$PERMIT_ROOT_LOGIN"  "$PERMIT_ROOT_LOGIN_NEW" "$LOG_FILE"
adds_to_sshd_config "$CLIENT_ALIVE_INTERVAL" "$CLIENT_ALIVE_INTERVAL_NEW" "$LOG_FILE"
adds_to_sshd_config "$CLIENT_ALIVE_COUNTMAX" "$CLIENT_ALIVE_COUNTMAX_NEW" "$LOG_FILE"

