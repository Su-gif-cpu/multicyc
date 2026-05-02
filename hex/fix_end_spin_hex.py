#!/usr/bin/env python3
"""Replace trailing jal x0,0 (0x0000006f) with beq x0,x0,+0 (0x00000063) in t*.hex (not code.hex)."""
from pathlib import Path

OLD = "0000006f"
NEW = "00000063"


def main():
    root = Path(__file__).resolve().parent
    n = 0
    for path in sorted(root.glob("t*.hex")):
        text = path.read_text(encoding="ascii", errors="replace")
        lines = [ln.strip() for ln in text.splitlines() if ln.strip()]
        if not lines or lines[-1].lower() != OLD:
            continue
        lines[-1] = NEW
        path.write_text("\n".join(lines) + "\n", encoding="ascii")
        print("patched", path.name)
        n += 1
    print("total", n, "files")


if __name__ == "__main__":
    main()
