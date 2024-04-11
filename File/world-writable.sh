#!/bin/bash

# makes the script run as root
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

# [ find /path/to/search -type f -perm -u+w ]
#
# this command  finds files with an criteria  
# google or chatgpt about this.
#
#




