#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

cd /home/admin

expected_header=$(head -n 1 data.csv)
threshold=$((32 * 1024))
minlines=100

for i in {0..9}; do
  file="data-0$i.csv"

  if [[ -f "$file" ]]; then
    file_header=$(head -n 1 "$file")
    if [[ "$file_header" != "$expected_header" ]]; then
      echo -n "NO"
      exit
    fi

    filesize=$(stat -c%s "$file")
    if ((filesize > threshold)); then
      echo -n "NO"
      exit
    fi

    lines=$(wc -l <"$file")
    if ((lines < minlines)); then
      echo -n "NO"
      exit
    fi
  else
    echo -n "NO"
    exit
  fi
done

echo -n "OK"
