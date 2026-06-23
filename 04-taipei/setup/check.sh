#!/bin/bash
res=$(curl -s localhost)
res=$(echo $res | tr -d '\r')
checksum=$(echo $res | md5sum | awk '{print $1}')

if [[ "$checksum" = "fe474f8e1c29e9f412ed3b726369ab65" ]]; then
  echo -n "OK"
else
  echo -n "NO"
fi
