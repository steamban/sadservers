Scenario: "Geneva": Renew an SSL Certificate

Level: Easy

Type: Fix

Tags: ssl  

Access: Email

Description: There's an Nginx web server running on this machine, configured to serve a simple "Hello, World!" page over HTTPS. However, the SSL certificate is expired.

Create a new SSL certificate for the Nginx web server with the same Issuer and Subject (same domain and company information).

Root (sudo) Access: True

Test: Certificate should not be expired: echo | openssl s_client -connect localhost:443 2>/dev/null | openssl x509 -noout -dates and the subject of the certificate should be the same as the original one: echo | openssl s_client -connect localhost:443 2>/dev/null | openssl x509 -noout -subject

The "Check My Solution" button runs the script /home/admin/agent/check.sh, which you can see and execute

Time to Solve: 10 minutes.
