#!/bin/bash

# Check if running as root (uncomment if needed)
# if [[ $(id -u) -ne 0 ]]; then
#   echo "Please run as root."
#   exit 1
# fi

clear
cat << "EOF"



               __________.__.__              _____                .__  __                
              \_   _____/|__|  |   ____     /     \   ____   ____ |__|/  |_  ___________ 
               |    __)  |  |  | _/ __ \   /  \ /  \ /  _ \ /    \|  \   __\/  _ \_  __ \
               |     \   |  |  |_\  ___/  /    Y    (  <_> )   |  \  ||  | (  <_> )  | \/
               \___  /   |__|____/\___  > \____|__  /\____/|___|  /__||__|  \____/|__|   
                   \/                 \/          \/            \/                       
EOF

BOLD='\e[1m'
UNDERLINE='\e[4m'
RED='\e[31m'
GREEN='\e[32m'
RESET='\e[0m'  
ITALIC="\e[3m"
yELLOW='\e[33m'

echo ' '
echo ' '
echo ' '
echo -e "                   ${BOLD}${GREEN}  *Options*: ${RESET}"
echo -e "               1.  ${YELLOW}${UNDERLINE}See current files integrity${RESET} ${ITALIC}[press: i]${RESET}"
echo -e "               2.  ${YELLOW}${UNDERLINE}Insert new files to monitor${RESET} ${ITALIC}[press: n]${RESET}"
read            option

if [[ $option == 'i']]; then
    exit 
fi

if [[ $option == 'n']]; then
    exit 
else
    cout "Not a valid command!"
fi

# ENCRYPTED_FILE="hashed_data.enc"
# HASH_FILE="file_hashes.txt"

# Encrypt file containing hashes
# openssl enc -aes-256-cbc -salt -in "$HASH_FILE" -out "$ENCRYPTED_FILE"

# Decrypt and verify integrity
# openssl enc -d -aes-256-cbc -in "$ENCRYPTED_FILE" -out "decrypted_hashes.txt"
# diff "$HASH_FILE" "decrypted_hashes.txt"
