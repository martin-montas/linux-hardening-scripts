#!/usr/bin/bash

if [ "$EUID" -ne 0 ] 
then    
    # makes sure that the file is run as root
    echo "Please run as root"
    exit
fi

var_log_file_permission () {
    #
    #creates basic /var/log/ file permissions
    #
    # Root ownership: The /var/log/ directory and its subdirectories should be owned by the root user. This 
    # ensures only the system or authorized processes can write to the logs. You can verify ownership with ls -l /var/log/.
    chmod 755 /var/log
    # Set ownership and permissions for log files
    find /var/log -type f -exec chmod 640 {} \;
}
var_log_file_permission 
