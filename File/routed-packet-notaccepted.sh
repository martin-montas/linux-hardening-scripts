#!/bin/bash

#                      File/routed-packet-notaccepted.sh
#
#                      Should run as root.
#                      By: martin-montas

IS_INSTALLED=$(sysctl net.ipv4.conf.all.accept_source_route)

if [[ $IS_INSTALLED != 0 ]]; then
    # sets the  kernel parameters to the sysctl.conf file
    echo "net.ipv4.conf.all.accept_source_route = 0"     >> /etc/sysctl.conf
    echo "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.conf

    # implements the kernel parameters on right now
    sysctl -w net.ipv4.conf.all.accept_source_route=0
    sysctl -w net.ipv4.conf.default.accept_source_route=0
    sysctl -w net.ipv4.route.flush=1
    exit 0
else
    echo "The parameters were already set." 
    exit 0
fi

