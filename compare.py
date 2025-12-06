#!/usr/bin/env python3
import sys
import math

if len(sys.argv) != 3:
    print(f"Usage: {sys.argv[0]} ans.txt out.txt")
    sys.exit(1)

ans_path = sys.argv[1]
out_path = sys.argv[2]

tol = 1e-2  # tolerance for comparison

with open(ans_path) as fa, open(out_path) as fb:
    ans_lines = fa.readlines()
    out_lines = fb.readlines()

if len(ans_lines) != len(out_lines):
    print(f"Line count differs: ans={len(ans_lines)}, out={len(out_lines)}")
    sys.exit(1)

max_err = 0.0
bad_count = 0

for i, (la, lb) in enumerate(zip(ans_lines, out_lines)):
    la = la.strip()
    lb = lb.strip()
    if not la and not lb:
        continue

    a_vals = list(map(float, la.split()))
    b_vals = list(map(float, lb.split()))

    if len(a_vals) != len(b_vals):
        print(f"Line {i+1}: different number of columns: ans={len(a_vals)}, out={len(b_vals)}")
        bad_count += 1
        continue

    for j, (a, b) in enumerate(zip(a_vals, b_vals)):
        err = abs(a - b)
        max_err = max(max_err, err)
        if err > tol:
            print(f"Line {i+1}, col {j+1}: ans={a:.6f}, out={b:.6f}, diff={err:.6e} > tol={tol}")
            bad_count += 1

print(f"\nMax abs diff = {max_err:.6e}")
if bad_count == 0:
    print("All values within tolerance")
else:
    print(f"{bad_count} values exceed tolerance")
