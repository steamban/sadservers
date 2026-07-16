# Worked Example: Geneva

## 1. Observe the problem

The SSL certificate on the Nginx web server is expired. Verify with:

```bash
echo | openssl s_client -connect localhost:443 2>/dev/null | openssl x509 -noout -dates
```

The `notAfter` date will be in the past.

## 2. Get the current certificate's subject

We need to recreate the certificate with the same subject:

```bash
echo | openssl s_client -connect localhost:443 2>/dev/null | openssl x509 -noout -subject
```

Output:

```
subject=CN = localhost, O = Acme, OU = IT Department, L = Geneva, ST = Geneva, C = CH
```

## 3. Generate a new self-signed certificate

Create a new certificate matching the original subject, valid for 10 years:

```bash
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -subj "/CN=localhost/O=Acme/OU=IT Department/L=Geneva/ST=Geneva/C=CH"
```

## 4. Install the new certificate

Copy the new files into place, backing up the old ones first:

```bash
sudo mv cert.pem /etc/nginx/ssl/nginx.crt
sudo mv key.pem /etc/nginx/ssl/nginx.key
```

If the originals need backing up first:

```bash
sudo mv /etc/nginx/ssl/nginx.crt{,.bk}
sudo mv /etc/nginx/ssl/nginx.key{,.bk}
sudo mv cert.pem /etc/nginx/ssl/nginx.crt
sudo mv key.pem /etc/nginx/ssl/nginx.key
```

## 5. Test and reload Nginx

```bash
sudo nginx -t
sudo nginx -s reload
```

## 6. Verify

Check that the new certificate is not expired and has the correct subject:

```bash
echo | openssl s_client -connect localhost:443 2>/dev/null | openssl x509 -noout -dates
echo | openssl s_client -connect localhost:443 2>/dev/null | openssl x509 -noout -subject
```

Then run the check script:

```bash
bash /home/admin/agent/check.sh
```

> **Key insight:** The problem requires matching the original certificate's subject fields exactly (CN, O, OU, L, ST, C). A self-signed certificate is sufficient — no CA is needed. The `-nodes` flag ensures the private key is not encrypted, which Nginx needs to load it without a passphrase.
