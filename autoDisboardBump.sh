#!/bin/bash

if test -n "$1"; then
    TOKEN="$1";
else
    echo "USAGE: $0 <token> <channelID>"
    exit -1
fi

if test -n "$2"; then
    CHANID="$2";
else
    echo "USAGE: $0 <token> <channelID>"
    exit -2
fi

POS='","tts":false}'
NONCE=857347495984889756

URL="https://discord.com/api/v9/channels/$CHANID/messages"

UA="Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0"

TYPE="Content-Type: application/json"
TOKEN="Authorization: $TOKEN"

while :
	do
        MIN=$((RANDOM%3+2))
        SEED=$((RANDOM%1000000+1))
		((NONCE=NONCE+1))
		SEEDED=$((NONCE+SEED))
		PRE='{"content":"!d bump","nonce":"'
		CONTENT=$PRE$SEEDED$POS
		LENGTH="Content-Length: "${#CONTENT}

		curl -X POST -A "$UA" -H "$TOKEN" -H "$LENGTH" -H "$TYPE" -d "$CONTENT" $URL
		sleep 2h $MIN
	done
