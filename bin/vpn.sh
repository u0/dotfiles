#!/usr/bin/env bash

windscribe status | tail -n 1 | awk '{if ($1 == "CONNECTED") print "UP"; else print "DOWN";}'
