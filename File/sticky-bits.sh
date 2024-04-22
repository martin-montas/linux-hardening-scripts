#!/bin/bash


if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

STICKY_BIT_SET=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev
-type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null)


if [[ -n "$STICKY_BIT_SET" ]]; then
    df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev
    -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | xargs -I '{}' chmod
    a+t '{}'

    echo "Done."
    exit 0
else
    echo "Sticky bit was already set."
    exit 1
fi



