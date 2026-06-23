#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(sha1sum /home/admin/highestip.txt | awk '{print $1}')
res=$(echo $res | tr -d '\r')

if [[ "$res" = "6ef426c40652babc0d081d438b9f353709008e93" || "$res" = "2ffbd804bd51afd43b1e62b87d047dc2a359d6c0" ]]; then
  echo -n "OK"
else
  echo -n "NO"
fi
