# Solution: Saint Paul — Merge Many CSVs

## Problem

Merge all 338 CSV files in `/home/admin/polldayregistrations_enregistjourduscrutin?????.csv` into a single `/home/admin/all.csv` with only one header row.

## Solution

```bash
head -n 1 polldayregistrations_enregistjourduscrutin62001.csv > /home/admin/all.csv && tail -n +2 -q polldayregistrations_enregistjourduscrutin?????.csv >> /home/admin/all.csv
```

## How it works

| Command | What it does |
|---------|-------------|
| `head -n 1 ...62001.csv > all.csv` | Takes the header line from one file and writes it as the single header in `all.csv` |
| `tail -n +2 -q ...?????.csv >> all.csv` | For all 338 files, outputs every line **starting from line 2** (skipping each file's header) and appends to `all.csv`. The `-q` flag suppresses `tail`'s filename banners. |

## Why `cat ... >> all.csv` fails

`cat` concatenates every file entirely, including each file's header. That gives 338 duplicate header rows, causing:

- **Line count check:** Expected 72,461 lines, but get 72,798 (337 extra headers)
- **Header uniqueness check:** Header appears 338 times (expected exactly 1)

Both checks in `check.sh` fail.

## Alternative approaches

### Using a loop to skip the first file

```bash
cp polldayregistrations_enregistjourduscrutin62001.csv all.csv
for f in polldayregistrations_enregistjourduscrutin?????.csv; do
  [ "$f" = "polldayregistrations_enregistjourduscrutin62001.csv" ] && continue
  tail -n +2 "$f" >> all.csv
done
```

### Using awk (one-liner)

```bash
awk 'FNR==1 && NR!=1 {next} {print}' polldayregistrations_enregistjourduscrutin*.csv > all.csv
```

- `FNR==1` = first line of current file
- `NR!=1` = not the very first line overall
- `{next}` = skip duplicate headers
- `{print}` = print everything else
