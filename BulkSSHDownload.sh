#!/bin/sh

# Simple script to download every file in a given directory from a remote ssh host

DIRECTORY=/usr/lib/*
PASSWORD=123456
PORT=22
USER=erarnitox
IP=bot.box
DEST=/usr/lib/

echo "Downloading libraries..."
for f in $DIRECTORY
do
  echo "Downloading $f file..."
  sshpass -p $PASSWORD scp -P $PORT $USER@$IP:$f $DEST
done
