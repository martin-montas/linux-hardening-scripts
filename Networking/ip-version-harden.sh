#!/usr/bin/bash

if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi



# Lines to be appended to the sysctl.conf file for persistent
# security thru boots.
lines=(
    "net.ipv4.tcp_rfc1337=1"
    "net.ipv4.conf.all.rp_filter=1"
    "net.ipv4.conf.default.rp_filter=1"
    "net.ipv4.conf.all.accept_redirects=0"
    "net.ipv4.conf.default.accept_redirects=0"
    "net.ipv4.conf.all.secure_redirects=0"
    "net.ipv4.conf.default.secure_redirects=0"
    "net.ipv6.conf.all.accept_redirects=0"
    "net.ipv6.conf.default.accept_redirects=0"
    "net.ipv4.conf.all.send_redirects=0"
    "net.ipv4.conf.default.send_redirects=0"
    "net.ipv4.icmp_echo_ignore_all=1"
    "net.ipv4.conf.all.accept_source_route=0"
    "net.ipv4.conf.default.accept_source_route=0"
    "net.ipv6.conf.all.accept_source_route=0"
    "net.ipv6.conf.default.accept_source_route=0"
    "net.ipv6.conf.all.accept_ra=0"
    "net.ipv6.conf.default.accept_ra=0"
)



# Append lines to the file
echo "${lines[@]}" | sudo tee -a /etc/sysctl.conf

# Apply changes (optional)
# Uncomment the following line if you want to apply changes without rebooting
sysctl -p




echo "Lines appended to /etc/sysctl.conf"
