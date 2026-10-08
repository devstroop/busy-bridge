"""Check that local relative links in the repo's markdown files resolve.

Usage: python scripts/docs/check_links.py   (from the repo root)
Exit 1 when any local link target is missing; http(s)/# links are skipped.
"""
import os
import re
import sys

ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))

def md_files():
    yield os.path.join(ROOT, "README.md")
    for sub in ("docs", "docs/archive", "examples", "tests/live"):
        d = os.path.join(ROOT, sub)
        if os.path.isdir(d):
            for f in sorted(os.listdir(d)):
                if f.endswith(".md"):
                    yield os.path.join(d, f)

def main() -> int:
    total = broken = 0
    for f in md_files():
        text = open(f, encoding="utf-8", errors="replace").read()
        base = os.path.dirname(f)
        for m in re.finditer(r"\]\((<?[^)\s]+>?)(?:\s+\"[^\"]*\")?\)", text):
            target = m.group(1).strip("<>")
            if target.startswith(("http://", "https://", "#", "mailto:")):
                continue
            total += 1
            path = os.path.normpath(os.path.join(base, target.split("#")[0]))
            if not os.path.exists(path):
                broken += 1
                print(f"BROKEN {os.path.relpath(f, ROOT)}: {target}")
    print(f"{total} local links checked, {broken} broken")
    return 1 if broken else 0

if __name__ == "__main__":
    sys.exit(main())
