# Worked Example: Bata

## 1. Search for "secret:" in /proc/sys

The problem says the file is somewhere under `/proc/sys` and its contents start with `"secret:"`. Use `grep -rl` to search recursively:

```bash
grep -rl "secret:" /proc/sys 2>/dev/null
```

| Piece | Purpose |
|---|---|
| `-r` | Recursive search |
| `-l` | List only filenames (not the matched line) |
| `2>/dev/null` | Suppress "Permission denied" errors (normal for most of `/proc/sys`) |

Output:

```
/proc/sys/kernel/core_pattern
```

Only one file matches.

## 2. Read the file

```bash
cat /proc/sys/kernel/core_pattern
```

Output:

```
secret:excalibur
```

The value after `"secret:"` is `excalibur`.

## 3. Write the secret

```bash
echo "excalibur" > /home/admin/secret.txt
```

## 4. Verify

```bash
md5sum /home/admin/secret.txt
```

Expected output:

```
a7fcfd21da428dd7d4c5bb4c2e2207c4  /home/admin/secret.txt
```

Or run the check script:

```bash
sh /home/admin/agent/check.sh
```

Should print `OK`.

> **Key insight:** `/proc/sys/kernel/core_pattern` controls where the kernel writes core dumps. There's nothing special about it — it's just a regular file in the procfs filesystem that happens to be world-readable and contain the secret. The trick is knowing to search rather than hunt manually through hundreds of sysctl entries. Most files under `/proc/sys` require root to read, but `core_pattern` is accessible to all users.
