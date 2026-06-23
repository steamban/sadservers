# Worked Example: Taipei

## 1. Observe the problem

```bash
curl localhost
```

No response or "connection refused". Port 80 is firewalled. There's a web server behind it — you just need to knock on the right door.

Check the setup:

```bash
ls -la /etc/knockd.conf
```

The file exists but is owned by root and not world-readable. Without sudo, you can't read it directly.

## 2. Learning: investigate the process

Find the knockd daemon:

```bash
ps aux | grep knock[d]
```

Sample output:

```
root       1234  0.0  0.1   1232   540 ?        Ss   11:00   0:00 /usr/sbin/knockd
```

Check its command line:

```bash
cat /proc/1234/cmdline | tr '\0' ' '
```

Output:

```
/usr/sbin/knockd
```

No arguments. The port sequence is inside `/etc/knockd.conf`, which is locked down.

### 2a. Try reading the config through the process's file descriptors

```bash
ls -la /proc/1234/fd/
```

You might see a descriptor pointing to `/etc/knockd.conf` (e.g. `fd 3`). On some systems you can read through it even without file-level permission, because access control is checked at `open()` time, not `read()` time:

```bash
cat /proc/1234/fd/3
```

This may or may not work depending on the system — worth trying.

### 2b. Check listening ports

```bash
cat /proc/net/tcp
```

This is world-readable and shows all TCP connection states. The hex port numbers can be decoded:

```bash
printf "%d\n" $((16#1A74))
```

If knockd pre-opens the knock port, you'd see it in a LISTEN state here.

### 2c. Check syslog

knockd may log its actions to syslog:

```bash
grep -i knock /var/log/syslog
```

If knockd logs when it opens port 80, you'd see the port and timestamp here.

## 3. Learning: binary search

If you had to find the exact port with minimal probes, you can bisect the port range. Scan half the ports, test curl, then narrow the half that worked:

```bash
nmap -p 1-32768 localhost
curl -s localhost | md5sum
```

If curl succeeds, the knock port is in 1–32768; if not, it's in 32769–65535. Repeat on the winning half. In ~15 iterations you identify the exact port.

## 4. Correct solution: brute force full port scan

You don't need to find the exact port. Just scan every TCP port — one of them is the knock:

```bash
nmap -p- localhost
```

`nmap -p-` sends a connection attempt to each TCP port (1–65535). One of those is the magic port that triggers knockd to open port 80.

Then verify:

```bash
curl localhost | md5sum
```

Expected output:

```
fe474f8e1c29e9f412ed3b726369ab65  -
```

> **Key insight:** Port knocking is security-by-obscurity. When you knock on every door, you don't need to know which one is the magic one. A full `nmap -p-` is the fastest and simplest solution — no config-reading, no binary search, no syslog grepping needed. The other approaches are useful when nmap isn't available or ports are spread across a sequence, but for a single-knock challenge, brute force wins.
> **Knocking:** In computer networking, port knocking is a method of externally opening ports on a firewall by generating a connection attempt on a set of prespecified closed ports. Once a correct sequence of connection attempts is received, the firewall rules are dynamically modified to allow the host which sent the connection attempts to connect over specific port(s). A variant called single packet authorization (SPA) exists, where only a single "knock" is needed, consisting of an encrypted packet.
