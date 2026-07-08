#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(md5sum /home/admin/secret.txt | awk '{print $1}')
res=$(echo $res | tr -d '\r')

if [[ "$res" = "a7fcfd21da428dd7d4c5bb4c2e2207c4" ]]; then
  echo -n "OK"
else
  echo -n "NO"
fi
