#!/bin/bash

#                      File/routed-packet-notaccepted.sh
#
#                      Should run as root.
#                      By: martin-montas
#
#       Rationale:
#
#
#       Assume this system was capable of routing packets to Internet
#       routable addresses on one interface and private addresses on another 
#       interface. Assume that the private addresses were not routable to 
#       the Internet routable addresses and vice versa. Under normal routing 
#       circumstances, an attacker from the Internet routable addresses could 
#       not use the system as a way to reach the private address systems. If,
#       however, source routed packets were allowed, they could be used to gain 
#       access to the private address systems as the route could be specified, 
#       rather than rely on routing protocols that did not allow this routing
       


ALL_IS_INSTALLED=$(sysctl net.ipv4.conf.all.accept_source_route | grep '0')
DEFAULT_IS_INSTALLED=$(sysctl net.ipv4.conf.default.accept_source_route | grep '0' )
ENABLED_COUNT=0

if [[ -z $ALL_IS_INSTALLED ]]; then
    # sets the  kernel parameters to the sysctl.conf file
    echo "net.ipv4.conf.all.accept_source_route = 0"     >> /etc/sysctl.conf

    # implements the kernel parameters on right now
    sysctl -w net.ipv4.conf.all.accept_source_route=0
    (( ENABLED_COUNT += 1 ))
fi

if [[ -z $DEFAULT_IS_INSTALLED ]]; then
    # sets the  kernel parameters to the sysctl.conf file
    echo "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.conf
    
    # implements the kernel parameters on right now
    sysctl -w net.ipv4.conf.default.accept_source_route=0
    (( ENABLED_COUNT += 1 ))
fi

# should only run once for all this settings:
if [[ $ENABLED_COUNT -gt 0 ]]; then
    sysctl -w net.ipv4.route.flush=1
    echo "more than one were enabled"
    exit 0

fi

