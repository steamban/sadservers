# Worked Example: Tokamachi

## 1. Understand the task

A reader process is running that reads from `/home/admin/namedpipe` one message at a time, then sleeps 2 seconds. The original writer command is:

```bash
/bin/bash -c 'while true; do echo "this is a test message being sent to the pipe" > /home/admin/namedpipe; done' &
```

This works for a while, then stops — the reader log shows no new messages (or very slow processing).

## 2. Why it breaks

The reader opens the pipe, reads one message, then sleeps 2 seconds. The original writer constantly reopens and writes to the pipe in a tight loop. When the reader wakes up, the writer has already flooded the pipe buffer — the reader only sees one message per cycle, and the rest pile up.

More critically, the checker also needs to write to the pipe:

```bash
echo $uui >/home/admin/namedpipe
```

With the writer in a tight loop, the checker almost never wins the race to open the pipe for writing — the writer beats it every time. So the checker's UUID never gets through.

## 3. The fix: add a sleep to the writer

```bash
nohup /bin/bash -c 'while true; do echo "this is a test message being sent to the pipe" > /home/admin/namedpipe; sleep 2; done' &
```

Adding `sleep 2` inside the loop creates gaps where the reader can close the pipe and the checker can successfully write its UUID.

## 4. Verify

Run the checker:

```bash
bash /home/admin/agent/check.sh
```

Should print `OK`.

> **Key insight:** Named pipes (FIFOs) block on open until both a reader and writer are connected. A tight write loop keeps reopening the pipe faster than the reader can cycle, starving other writers. A sleep in the writer loop lets other processes (the checker, the reader) get a turn. In production you'd use proper IPC instead of sleep-based coordination, but this lab specifically tests whether you can diagnose FIFO contention.
