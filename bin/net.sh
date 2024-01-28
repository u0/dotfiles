#!/bin/sh

if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  echo "UP"
else
  echo "DOWN"
fi
