#!/bin/bash

# Configuration variables
source_dir="/home/bob/personal"
backup_filename="backup_$(date +'%Y%m%d_%H%M%S').tar.gz"
remote_user="pi"
remote_host="10.0.0.25"
remote_dir="/home/pi/"

# Change to the source directory
cd "$source_dir" || exit

# Create a compressed archive of the source directory
tar -czf "$backup_filename" .

# Transfer the backup archive to the remote host using scp
scp "$backup_filename" "$remote_user@$remote_host:$remote_dir"

# Check the exit status of scp
if [ $? -eq 0 ]; then
    echo "Backup transfer successful."
    # Clean up the local backup file after successful transfer
    rm "$backup_filename"
else
    echo "Backup transfer failed."
fi

