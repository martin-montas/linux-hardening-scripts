#!/usr/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Set default DROP policy
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP

# Allow established connections
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH (modify port if needed)
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Add more rules as needed (refer to secure configurations for examples)

# Save iptables configuration (optional)
# sudo iptables-save > /etc/iptables/rules.v4

echo "Iptables configuration applied!"
