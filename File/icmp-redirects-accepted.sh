#!/bin/bash

#                       Service/icmp-redirects-accepted.sh
#                       should be run as root.
#
#
#               This script was written thanks to a pdf related to the CIS 
#               Benchmark. Rationale:
#
#               Attackers could use bogus ICMP redirect messages to maliciously 
#               alter the system routing tables and get them to send packets to 
#               incorrect networks and allow your system packets to be captured.


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

ALL_ENABLED=$(sysctl net.ipv4.conf.all.accept_redirects | grep '0')
DEFAULT_ENABLED=$(sysctl net.ipv4.conf.default.accept_redirects | grep '0')
WAS_SET=0
if [[ -n $ALL_ENABLED  ]]; then

    # sets the given parameters to the sysctl.conf file:
    echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
    (( WAS_SET += 1 ))
    
    # enforces the parameters without booting:
    sysctl -w net.ipv4.conf.all.accept_redirects=0

fi
if [[ -n $DEFAULT_ENABLED ]]; then
    # sets the given parameters to the sysctl.conf file:
    echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.conf

    # enforces the parameters without booting:
    sysctl -w net.ipv4.conf.default.accept_redirects=0
    (( WAS_SET += 1 ))
fi

# should only run once for all this settings:
if [[ $WAS_SET -gt 0 ]]; then
     sysctl -w net.ipv4.route.flush=1

 else
     echo "Not all of the settings were enabled."
fi
