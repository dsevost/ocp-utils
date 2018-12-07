#!/bin/bash

URL=${1}

if [ -z "$URL" ] ; then
    echo "SYNTAX: $BASH_SOURCE <HOST_NAME[:PORT]>"
    exit 1
fi

HOST=${URL%%:*}
PORT=${URL##*:}

[ "$HOST" = "$PORT" ] && PORT=":443" || PORT=":$PORT"

openssl s_client \
    -connect $HOST$PORT \
    -servername $HOST \
    -showcerts < /dev/null 2> /dev/null \
    | sed --quiet '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p'