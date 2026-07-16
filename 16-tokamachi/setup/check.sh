#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

if ! ps auxf | grep -q 'pipe" > /home/admin/named[pipe]'; then
  echo -n "NO"
  exit
fi

uui=$(uuidgen | cut -c1-8)
echo $uui >/home/admin/namedpipe
sleep 1

if grep -q "$uui" /home/admin/reader.log; then
  echo -n "OK"
else
  echo -n "NO"
fi
