#!/usr/bin/env bash
set -euo pipefail

SU2_ROOT=""
YES=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --su2-root) SU2_ROOT="${2:-}"; shift 2 ;;
    --yes) YES=1; shift ;;
    *) echo "Usage: $0 --su2-root /path/to/SU2 --yes" >&2; exit 2 ;;
  esac
done

[[ -n "$SU2_ROOT" ]] || { echo "ERROR: --su2-root is required" >&2; exit 2; }
DST="$(readlink -f "$SU2_ROOT")/coupling/SU2_PATO"
[[ -d "$DST" ]] || { echo "Nothing installed at $DST"; exit 0; }
[[ $YES -eq 1 ]] || { echo "Refusing to remove without --yes: $DST" >&2; exit 1; }
rm -rf "$DST"
echo "UNINSTALL_SU2_PATO_COUPLING=PASS"
