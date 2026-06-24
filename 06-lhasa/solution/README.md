# Lhasa: Easy Math — Solution

## Problem

File `/home/admin/scores.txt` has two columns (line number and score). Find the arithmetic mean of the numbers in the second column with exactly two decimal digits, **no rounding**. Save to `/home/admin/solution`.

## Solution (Option 1: awk)

```bash
awk '{sum+=$2} END {printf "%.2f\n", int((sum/NR)*100)/100}' /home/admin/scores.txt > /home/admin/solution
```

### Breakdown

| Piece | What it does |
|---|---|
| `{sum+=$2}` | Accumulate column 2 values |
| `END { ... }` | Run after all lines processed |
| `NR` | Total line count (number of scores) |
| `sum/NR` | Raw average (e.g., `5.204`) |
| `int((sum/NR)*100)/100` | **Truncate** to 2 decimal places: multiply by 100, drop fraction, divide by 100 |
| `printf "%.2f\n"` | Print with exactly 2 decimal places (pads `5.2` → `5.20`) |

### Verify

```bash
md5sum /home/admin/solution
# 6d4832eb963012f6d8a71a60fac77168  solution
```
