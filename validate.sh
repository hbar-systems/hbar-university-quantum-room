#!/usr/bin/env bash
# validate.sh — pre-flight check for brain-app.yaml against the brain-app/v1 schema.
#
# Why: the brain validates the manifest on install AND update. An invalid field
# (e.g. description over 240 chars) makes the Update endpoint return 422 and the
# Apps-page button look like a silent no-op. Run this before every push.
#
# Self-contained: stdlib Python only (no PyYAML / jsonschema needed). The
# brain-app/v1 constraints are embedded below; if a brainfoundry-nous checkout
# is found, the script also cross-checks the embedded limits against the live
# schema and warns on drift.
#
# Usage:  ./validate.sh            # validates ./brain-app.yaml
#         ./validate.sh path.yaml
set -euo pipefail
MANIFEST="${1:-$(dirname "$0")/brain-app.yaml}"

python3 - "$MANIFEST" <<'PY'
import sys, re, json, os

manifest_path = sys.argv[1]

# --- brain-app/v1 constraints (kept in sync with brain-app.schema.json) ---
CONST   = {"dialect": "brain-app/v1"}
MINLEN  = {"name": 1, "description": 1, "license": 1}
MAXLEN  = {"name": 100, "description": 240}
PATTERN = {
    "id":      r"^[a-z0-9][a-z0-9-]{1,62}[a-z0-9]$",
    "version": r"^v?[0-9]+\.[0-9]+\.[0-9]+(-[a-z0-9.-]+)?$",
    "repo":    r"^https://(github\.com|gitlab\.com|codeberg\.org)/",
}
REQUIRED = ["dialect","id","name","version","description","license","author","repo","tab","entries"]

# --- minimal top-level YAML scalar/block reader (no PyYAML dependency) ---
# Captures `key: value` at column 0. Empty value => a nested block (object/list),
# recorded as "present" so required-object fields (author/tab/entries) pass.
scalars, present = {}, set()
for raw in open(manifest_path, encoding="utf-8"):
    if not raw.strip() or raw.lstrip().startswith("#"):
        continue
    if raw[0] in " \t-":               # nested / list item — skip
        continue
    m = re.match(r"^([A-Za-z_][A-Za-z0-9_]*):(.*)$", raw.rstrip("\n"))
    if not m:
        continue
    key, val = m.group(1), m.group(2).strip()
    present.add(key)
    if val and not val.startswith("#"):
        # strip surrounding quotes if any
        if len(val) >= 2 and val[0] == val[-1] and val[0] in "\"'":
            val = val[1:-1]
        scalars[key] = val

errors, oks = [], []

for f in REQUIRED:
    if f not in present:
        errors.append(f"missing required field: {f}")
    else:
        oks.append(f"present: {f}")

for f, c in CONST.items():
    if f in scalars and scalars[f] != c:
        errors.append(f"{f} must be '{c}' (got '{scalars[f]}')")

for f, n in MINLEN.items():
    if f in scalars and len(scalars[f]) < n:
        errors.append(f"{f} too short: {len(scalars[f])} < {n}")

for f, n in MAXLEN.items():
    if f in scalars:
        L = len(scalars[f])
        if L > n:
            errors.append(f"{f} TOO LONG: {L}/{n} chars")
        else:
            oks.append(f"{f} length ok: {L}/{n}")

for f, pat in PATTERN.items():
    if f in scalars and not re.search(pat, scalars[f]):
        errors.append(f"{f} fails pattern {pat} (got '{scalars[f]}')")

# --- optional drift check against the live schema ---
def find_schema():
    env = os.environ.get("BRAIN_APP_SCHEMA")
    if env and os.path.exists(env):
        return env
    here = os.path.dirname(os.path.abspath(manifest_path))
    cand = os.path.join(here, "..","..","..","brainfoundry","repos",
                        "brainfoundry-nous","api","schemas","brain-app.schema.json")
    cand = os.path.normpath(cand)
    return cand if os.path.exists(cand) else None

sp = find_schema()
if sp:
    try:
        sc = json.load(open(sp)).get("properties", {})
        for f, n in MAXLEN.items():
            live = sc.get(f, {}).get("maxLength")
            if live is not None and live != n:
                print(f"  [drift] schema maxLength for {f} is {live}, script has {n} — update validate.sh")
    except Exception as e:
        print(f"  [drift-check skipped: {e}]")

print(f"\nvalidating {manifest_path}")
for o in oks:
    print(f"  ok   {o}")
if errors:
    print()
    for e in errors:
        print(f"  FAIL {e}")
    print(f"\n{len(errors)} problem(s) — the brain would reject this manifest. Fix before pushing.")
    sys.exit(1)
print("\nPASS — manifest satisfies the brain-app/v1 constraints.")
PY
