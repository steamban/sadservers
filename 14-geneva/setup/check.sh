#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# Check if the certificate is expired
not_after_date=$(echo | openssl s_client -connect localhost:443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)
not_after_timestamp=$(date -d "$not_after_date" +%s)
current_timestamp=$(date +%s)

if [ "$current_timestamp" -gt "$not_after_timestamp" ]; then
  echo -n "NO"
  exit
fi

# Define expected fields and their values
expected_fields=(
  "CN=localhost"
  "O=Acme"
  "OU=ITDepartment"
  "L=Geneva"
  "ST=Geneva"
  "C=CH"
)

# Extract the subject fields from the certificate
cert_subject=$(echo | openssl s_client -connect localhost:443 2>/dev/null | openssl x509 -noout -subject | sed 's/^subject= //g')
cert_subject=$(echo "$cert_subject" | tr -d '[:space:]' | tr ',' '/' | tr -d '"')

# test positive different order
#cert_subject="subject=CN=localhost/L=Geneva/ST=Geneva/O=Acme/C=CH/OU=ITDepartment"
# test negative wrong value
#cert_subject="subject=CN=domain/L=Geneva/ST=Geneva/O=Acme/C=CH/OU=ITDepartment"

# Check if all expected fields are present in the certificate subject
valid=true
for field in "${expected_fields[@]}"; do
  if [[ ! "$cert_subject" == *"$field"* ]]; then
    valid=false
    break
  fi
done

if [ "$valid" = false ]; then
  echo -n "NO"
else
  echo -n "OK"
fi
