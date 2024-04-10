#!/usr/bin/bash

#               check-permissions.sh

#               should be run as root
#               Author: @martin-montas
#               this script checks the modification time of files in a directory
#               and checks if the modification time is after a specific date
#               and prints the filename if it is after the threshold

DIRS=(
    #"/home/bob/personal/python-project/sysadmin-projects/linux-management-scripts/" 
    "/etc/"
    # "/bin"
    # "/sbin"
    # "/usr/bin"
    # "/usr/sbin"
)

# Define secure permissions
SECURE_PERMISSIONS="644"

# Assuming DIRS is properly defined as an array of directories
# Example:
# DIRS=(/path/to/dir1 /path/to/dir2)

# Loop over files found by `find` command
find "${DIRS[@]}" -type f | while IFS= read -r filename; do

    LAST_MODIFIED=$(stat --format="%a" "$filename" 2>/dev/null) 

done
