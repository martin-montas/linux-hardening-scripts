#!/usr/bin/bash


#            this script adds parameters to the systemd unit file
#            should be run as root
#
#            by adding the parameters to the systemd unit file
#            and then restarting the service
#            you make sure you can not access the service
#            from any other user
#            and prevents other users access to the service
#            
#            Author: @eto330
#


if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi

system_parameters=(
'NoNewPrivileges=yes'
'PrivateTmp=yes'
'PrivateDevices=yes'
'DevicePolicy=closed'
'ProtectSystem=strict'
'ProtectHome=read-only'
'ProtectControlGroups=yes'
'ProtectKernelModules=yes'
'ProtectKernelTunables=yes'
'RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6 AF_NETLINK'
'RestrictNamespaces=yes'
'RestrictRealtime=yes'
'RestrictSUIDSGID=yes'
'MemoryDenyWriteExecute=yes'
'LockPersonality=yes'
)


read -p "to what file do you want to append?" file_name

for text_to_append in "${system_parameters[@]}"; do

    sed_command="/^\[Service\]/a $text_to_append"
    sed -i "$sed_command" "$file_name"
done

systemctl restart "$file_name"

echo "Restarted $file_name"








