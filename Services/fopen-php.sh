#!/usr/bin/bash
#
#                   File/fopen-php.sh
#                   should be run as root
#                   Author: @eto330
#                   this script changes the value of allow_url_fopen from Off to On
#                   in the file /etc/php/8.2/cli/php.ini for extra security as 
#                   stated by Lynis audit security.
#

if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi

FILE="/etc/php/8.2/cli/php.ini"
OLD_LINE="allow_url_fopen = Off"
NEW_LINE="allow_url_fopen = On"


sed -i "s/$OLD_LINE/$NEW_LINE/g" "$FILE" 




