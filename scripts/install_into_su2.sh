#!/usr/bin/env bash
set -euo pipefail

SU2_ROOT=""
FORCE=0

usage() {
  echo "Usage: $0 --su2-root /path/to/SU2 [--force]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --su2-root) SU2_ROOT="${2:-}"; shift 2 ;;
    --force) FORCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "ERROR: unknown argument $1" >&2; usage >&2; exit 2 ;;
  esac
done

[[ -n "$SU2_ROOT" ]] || { echo "ERROR: --su2-root is required" >&2; exit 2; }
SU2_ROOT="$(readlink -f "$SU2_ROOT")"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/coupling/SU2_PATO"
DST="$SU2_ROOT/coupling/SU2_PATO"

[[ -d "$SU2_ROOT" ]] || { echo "ERROR: SU2 root not found: $SU2_ROOT" >&2; exit 1; }
[[ -f "$SRC/runtime/run_persistent_coupling.py" ]] || { echo "ERROR: coupling source missing" >&2; exit 1; }

if [[ -e "$DST" && $FORCE -ne 1 ]]; then
  echo "ERROR: destination already exists: $DST" >&2
  echo "Re-run with --force only after backing up/reviewing the existing installation." >&2
  exit 1
fi

if [[ -e "$DST" && $FORCE -eq 1 ]]; then
  rm -rf "$DST"
fi

mkdir -p "$(dirname "$DST")"
cp -a "$SRC" "$DST"

python3 -m py_compile \
  "$DST/runtime/run_persistent_coupling.py" \
  "$DST/map_su2_profile_to_pato_faces.py" \
  "$DST/map_pato_temperature_to_su2.py"

bash -n "$DST/runtime/run_persistent_coupling.sh"
bash -n "$DST/runtime/run_pysu2.sh"

echo "INSTALL_SU2_PATO_COUPLING=PASS"
echo "INSTALLED_AT=$DST"
