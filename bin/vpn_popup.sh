#!/bin/sh
vpn() {
    windscribe status | tail -n 1 | awk '{if ($1 == "CONNECTED") print " UP"; else print " DOWN";}'
}

# Create the popup and make it live for 3 seconds
old=" "
while :;
do
    status=$(vpn)
    if [ "${status}" != "${old}" ]
    then
        old=$status
        dunstify "$status" -u LOW
    fi
    sleep 60
done
