#!/usr/bin/bash


if [[ $(id -u) -ne 0 ]]; then
   echo "Please run as root."
   exit 1
fi

MY_SESSION_PID=$( ps -o pid,tty,args -p $$   | awk '{print $1}' | tail -n 1 | awk '{print $1}')
ALL_TERMINAL_PID=$(ps -aux |  grep -P 'pts/[0-9]' | awk '{print $2}')                                       

for pid in $ALL_TERMINAL_PID; do
    if [[ "$pid" == "$MY_SESSION_PID" ]]; then
        continue
    else
        kill "$pid"
    fi
done





