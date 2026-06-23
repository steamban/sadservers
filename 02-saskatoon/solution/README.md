# Worked Example: Saskatoon

## 1. Examine the log file

```bash
head /home/admin/access.log
```

Sample output:

```
66.249.73.135 - - [17/May/2015:10:05:03 +0000] "GET /presentations/logstash-monitorama-2013/images/kibana-search.png HTTP/1.1" 200 203023
46.105.14.53 - - [17/May/2015:10:05:43 +0000] "GET /presentations/logstash-monitorama-2013/images/kibana-dashboard.png HTTP/1.1" 200 171717
...
```

Each line is an Apache common log format entry. The requester's IP is the first column (first space-delimited field).

Check the total line count:

```bash
wc -l /home/admin/access.log
```

## 2. Find the most frequent IP

Extract the first column, count occurrences per IP, and sort by frequency.

### Approach A: Your method

```bash
awk '{print $1}' /home/admin/access.log | sort | uniq -c | sort | tail -1
```

Breaking it down:

| Command | Purpose |
|---|---|
| `awk '{print $1}'` | Extracts the first space-separated field (the IP) from each line |
| `sort` | Groups identical IPs together (required before `uniq -c`) |
| `uniq -c` | Counts consecutive duplicate lines, prefixing each unique value with its count |
| `sort` | Sorts counts lexicographically ascending (smallest first) |
| `tail -1` | Takes the last line (highest count) |

Output:

```
    482 66.249.73.135
```

The IP `66.249.73.135` has 482 requests — the highest in the file.

**Why `sort` (without `-n`) works here:** `uniq -c` left-pads all counts to the same width with spaces (e.g. ` 9`, ` 99`, ` 482`). Because the widths are equal, plain lexicographic `sort` orders them correctly. If counts ever reach 10,000+, the padding shifts and `sort` would break (`10000` sorts before ` 9999`). Within this scenario the max is 482, so it's safe.

### Approach B: Explicit numeric sort (recommended)

```bash
awk '{print $1}' /home/admin/access.log | sort | uniq -c | sort -n | tail -1
```

`-n` forces a true numeric sort, making it robust at any scale. No different in practice here, but the intent is clearer and you never have to think about padding.

| Approach | Robust? | Readability |
|---|---|---|
| `sort \| tail -1` | Fragile beyond 4-digit counts | Clever, concise |
| `sort -n \| tail -1` | Always works | Explicit, obvious |

## 3. Write the solution

```bash
echo "66.249.73.135" > /home/admin/highestip.txt
```

## 4. Verify

Check the SHA1 checksum:

```bash
sha1sum /home/admin/highestip.txt
```

Expected output:

```
6ef426c40652babc0d081d438b9f353709008e93  /home/admin/highestip.txt
```

Double-check the count matches:

```bash
grep -c -F -f /home/admin/highestip.txt /home/admin/access.log
```

Should return `482`.

## 5. One-liner (extract → count → write directly)

With `sort | tail -1`:

```bash
awk '{print $1}' /home/admin/access.log | sort | uniq -c | sort | tail -1 | awk '{print $2}' > /home/admin/highestip.txt
```

With `sort -n | tail -1`:

```bash
awk '{print $1}' /home/admin/access.log | sort | uniq -c | sort -n | tail -1 | awk '{print $2}' > /home/admin/highestip.txt
```

The final `awk '{print $2}'` strips the count, leaving just the IP.

> **Key insight:** `uniq -c` only counts *adjacent* duplicate lines. If you omit `sort`, an IP that appears in non-consecutive lines will be counted multiple times instead of once, giving a wrong result. Always `sort` before `uniq -c`.
