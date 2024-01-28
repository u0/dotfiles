#!/bin/sh
net() {
    ping -c 1 1.1.1.1 >/dev/null
    if [ $? -eq 0 ]
    then
        echo "Net: UP"
    else
        echo "Net: DOWN"
    fi
}

# Create the popup and make it live for 3 seconds
old=" "
while :;
do
    status=$(net)
    if [ "${status}" != "${old}" ]
    then
        old=$status
        dunstify "$status" -u LOW
    fi
    sleep 60
done
