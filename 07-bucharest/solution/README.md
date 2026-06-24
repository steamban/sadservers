# Worked Example: Bucharest

## 1. Observe the problem

Try the test command:

```bash
PGPASSWORD=app1user psql -h 127.0.0.1 -d app1 -U app1user -c '\q'
```

Output:

```
psql: error: FATAL:  pg_hba.conf rejects connection for host "127.0.0.1", user "app1user", database "app1", SSL off
```

The error points directly at `pg_hba.conf` — Postgres's host-based authentication file.

## 2. Find and inspect pg_hba.conf

```bash
sudo cat /etc/postgresql/13/main/pg_hba.conf
```

Near the bottom, you'll find lines like:

```
# IPv4 local connections:
host    all             all             all                     reject
host    all             all             all                     reject
```

The `reject` method explicitly denies any matching connection. These two lines block all IPv4 connections to any database by any user.

## 3. Fix the configuration

Open the file with an editor:

```bash
sudo vim /etc/postgresql/13/main/pg_hba.conf
```

Change the two `reject` lines to use `md5` (password-based authentication). The corrected lines should look like:

```
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
```

## 4. Restart PostgreSQL

```bash
sudo systemctl restart postgresql@13-main.service
```

## 5. Verify

```bash
PGPASSWORD=app1user psql -h 127.0.0.1 -d app1 -U app1user -c '\q'
```

No output means success — the connection works.

> **Key insight:** The `pg_hba.conf` file controls *who* can connect *how*. A `reject` line denies all matching connections before later allow rules are even evaluated. Always check `pg_hba.conf` first when Postgres refuses a connection — the error message tells you exactly which file is responsible.
