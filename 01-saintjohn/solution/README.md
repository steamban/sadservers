# Worked Example: Saint John

## 1. Observe the problem

```bash
tail -f /var/log/bad.log
```

You'll see lines being appended continuously. The disk is filling up.

## 2. Find the culprit process

Use `lsof` to see which process has the log file open:

```bash
lsof /var/log/bad.log
```

Output (typical):

```
COMMAND     PID   USER   FD   TYPE  DEVICE  SIZE/OFF  NODE  NAME
badlog.py   621  ubuntu  3w   REG   259,1   10629     67701 /var/log/bad.log
```

The process is `badlog.py` with PID `621`.

Alternatively, a one-liner to get just the PID:

```bash
lsof -t /var/log/bad.log
```

## 3. Terminate it

```bash
kill 621
```

Or in one step:

```bash
kill $(lsof -t /var/log/bad.log)
```

If it doesn't respond, use `kill -9` (but `kill` alone usually works).

## 4. Verify

```bash
sh /home/admin/agent/check.sh
```

The check script confirms the log file size has stopped changing. Pass.

> **Key insight:** Deleting the `badlog.py` script file does nothing — the process is already in memory. You must kill the running process. Deleting the log file is also explicitly forbidden by the problem.
