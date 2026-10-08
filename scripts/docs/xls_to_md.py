"""Convert one .xls workbook to a markdown file (one '## sheet' section each).

Row 0 is treated as the header when it is fully populated with text; otherwise
synthetic column headers are used, keeping the grid lossless. Written for the
BUSY database-design workbooks (no tabulate dependency).
"""
import sys
import math

import pandas as pd


def cell(v):
    if v is None or (isinstance(v, float) and math.isnan(v)):
        return ""
    if isinstance(v, float) and v.is_integer():
        return str(int(v))
    return str(v).replace("|", "\\|").replace("\n", " ")


def main(src: str, out: str) -> None:
    xl = pd.ExcelFile(src)
    with open(out, "w", encoding="utf-8", newline="\n") as f:
        f.write(
            f"<!-- generated from {src.rsplit('/', 1)[-1].rsplit(chr(92), 1)[-1]}"
            " by scripts/docs/xls_to_md.py -->\n"
        )
        f.write(f"# {src.rsplit('/', 1)[-1].rsplit(chr(92), 1)[-1]}\n")
        for sheet in xl.sheet_names:
            df = xl.parse(sheet, header=None)
            if df.empty:
                continue
            f.write(f"\n## {sheet}\n\n")
            rows = [[cell(v) for v in row] for row in df.values.tolist()]
            ncols = max(len(r) for r in rows)
            rows = [r + [""] * (ncols - len(r)) for r in rows]
            first = rows[0]
            if all(c != "" for c in first) and len(set(first)) == len(first):
                header, body = first, rows[1:]
            else:
                header = [f"col{i}" for i in range(ncols)]
                body = rows
            f.write("| " + " | ".join(header) + " |\n")
            f.write("|" + "---|" * ncols + "\n")
            for r in body:
                f.write("| " + " | ".join(r) + " |\n")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
