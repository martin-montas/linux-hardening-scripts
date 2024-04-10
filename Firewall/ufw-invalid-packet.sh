#!/usr/bin/bash

 if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi

FILE_V4="/etc/ufw/before.rules"
FILE_V6="/etc/ufw/before6.rules"

RULE_V4="""
-A ufw-before-input -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j ufw-logging-deny
-A ufw-before-input -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j DROP
"""

RULE_V6="""
-A ufw-before-input -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j ufw-logging-deny
-A ufw-before-input -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j DROP
"""

if [ -f "$FILE_V4" ]; then
    echo "$RULE_V4" | sudo tee -a "$FILE_V4" > /dev/null
else
    echo "$RULE_V4" | sudo tee "$FILE_V4" > /dev/null
fi

if [ -f "$FILE_V6" ]; then
    echo "$RULE_V6" | sudo tee -a "$FILE_V6" > /dev/null
else
    echo "$RULE_V6" | sudo tee "$FILE_V6" > /dev/null
fi

echo "Iptables configuration applied!"


