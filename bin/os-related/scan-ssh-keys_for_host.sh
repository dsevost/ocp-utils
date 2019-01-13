#!/bin/bash

[ -z "$*" ] && { echo "SYNTAX: $BASH_SOURCE <host [host [...]]>" ; exit 1; }

for h in $* ; do 
    ssh-keyscan -H $h >> ~/.ssh/known_hosts
done
