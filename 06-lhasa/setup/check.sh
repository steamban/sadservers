#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)
res=$(md5sum /home/admin/solution | awk '{print $1}')
res=$(echo $res | tr -d '\r')

if [[ "$res" = "6d4832eb963012f6d8a71a60fac77168" ]]; then
  echo -n "OK"
else
  echo -n "NO"
fi
