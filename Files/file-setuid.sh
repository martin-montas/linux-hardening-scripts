#!/usr/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


# --------------a set of important files that shouldn't  have setuid ------------------------------
chmod u-s               /bin/ping
chmod u-s               /bin/traceroute
chmod u-s               /usr/bin/chsh
chmod u-s               /usr/bin/passwd
chmod u-s               /usr/bin/sudo
chmod u-s               /usr/bin/newgrp
chmod u-s               /usr/bin/at
chmod u-s               /usr/bin/locate
chmod u-s               /usr/bin/wall
chmod u-s               /usr/bin/write




