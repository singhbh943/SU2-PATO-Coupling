#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-.}"
ROOT="$(readlink -f "$ROOT")"

required=(
  README.md LICENSE THIRD_PARTY_NOTICES.md CITATION.cff
  coupling/SU2_PATO/runtime/run_persistent_coupling.py
  coupling/SU2_PATO/runtime/run_persistent_coupling.sh
  coupling/SU2_PATO/runtime/run_pysu2.sh
  coupling/SU2_PATO/map_su2_profile_to_pato_faces.py
  coupling/SU2_PATO/map_pato_temperature_to_su2.py
)
for rel in "${required[@]}"; do
  [[ -f "$ROOT/$rel" ]] || { echo "ERROR missing $rel" >&2; exit 1; }
done

python3 -m py_compile \
  "$ROOT/coupling/SU2_PATO/runtime/run_persistent_coupling.py" \
  "$ROOT/coupling/SU2_PATO/map_su2_profile_to_pato_faces.py" \
  "$ROOT/coupling/SU2_PATO/map_pato_temperature_to_su2.py"

bash -n "$ROOT/coupling/SU2_PATO/runtime/run_persistent_coupling.sh"
bash -n "$ROOT/coupling/SU2_PATO/runtime/run_pysu2.sh"

if grep -RInE --exclude-dir=.git \
  '(/home/[[:alnum:]_.-]+/|hy2foam_catelytic|SU2_PRODUCTION|SU2_PATO_CASES|SU2_PATO_COUPLING/)' \
  "$ROOT/coupling"; then
  echo "ERROR: local/private path found in coupling sources" >&2
  exit 1
fi

if find "$ROOT" -type f \( \
  -name '*.su2' -o -name 'restart*.dat' -o -name '*.vtu' -o -name '*.vtk' -o \
  -name '*.log' -o -name '*.out' -o -name '*.err' \) -print | grep -q .; then
  echo "ERROR: simulation artifact found in release repository" >&2
  exit 1
fi

# Flag unexpectedly large files (>5 MiB).
if find "$ROOT" -type f -size +5M -print | grep -q .; then
  echo "ERROR: file larger than 5 MiB found; review before release" >&2
  find "$ROOT" -type f -size +5M -print >&2
  exit 1
fi

echo "RELEASE_CHECK=PASS"
