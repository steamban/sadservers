# Worked Example: Minneapolis

## 1. Understand the task

Break `data.csv` in `/home/admin/` into exactly 10 files `data-00.csv` through `data-09.csv`, each:

- Containing the same header (first line) as the original
- No larger than 32 KB
- At least 100 lines

## 2. Inspect the file

```bash
cd /home/admin
wc -l data.csv
head -1 data.csv
ls -lh data.csv
```

## 3. The problem with line-based split

A naive `split -n l/10` puts the header only in the first file. The check script verifies every file has the same header, so all but `data-00.csv` fail.

A line-count loop (`tail ... | head ...`) can overflow 32 KB because lines have variable length — the first or last chunk may be longer than average.

## 4. Solution: byte-split, then inject the header

```bash
split -n 10 -d data.csv data-
h=$(head -1 data.csv)
for f in data-0[0-9]; do
  echo "$h" > "$f.csv"
  cat "$f" >> "$f.csv"
  rm "$f"
done
```

**Explanation:**
- `split -n 10 -d data.csv data-` splits the file into 10 equal-sized byte chunks (roughly 31 KB each). The `-d` flag uses numeric suffixes.
- This creates `data-00`, `data-01`, ..., `data-09` (no `.csv` extension).
- The loop writes the original header into each file, appends the chunk data, and removes the temporary split files.
- The result is `data-00.csv` through `data-09.csv`, each starting with the correct header and staying safely under 32 KB.

## 5. Verify

```bash
sh /home/admin/agent/check.sh
```

Output should be `OK`.

> **Key insight:** The note says "disregard broken lines" — you don't need to split on line boundaries. A byte-level split with `split -n` guarantees equal-sized chunks. The only extra step is injecting the header into every file, which is what `head -1` + a loop does. This avoids both the "header missing" problem of a naive split and the "variable line length" problem of line-count-based approaches.
