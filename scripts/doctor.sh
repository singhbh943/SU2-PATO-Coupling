#!/usr/bin/env bash
set -u

SU2_ROOT=""
PATO_DIR_ARG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --su2-root) SU2_ROOT="${2:-}"; shift 2 ;;
    --pato-dir) PATO_DIR_ARG="${2:-}"; shift 2 ;;
    *) echo "Usage: $0 --su2-root /path/to/SU2 [--pato-dir /path/to/PATO]" >&2; exit 2 ;;
  esac
done

fail=0
check_file() {
  if [[ -f "$1" ]]; then echo "PASS file $1"; else echo "FAIL missing $1"; fail=1; fi
}
check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then echo "PASS command $1=$(command -v "$1")"; else echo "WARN command not on PATH: $1"; fi
}

[[ -n "$SU2_ROOT" ]] || { echo "FAIL --su2-root is required"; exit 2; }
SU2_ROOT="$(readlink -f "$SU2_ROOT")"

check_file "$SU2_ROOT/coupling/SU2_PATO/runtime/run_persistent_coupling.py"
check_file "$SU2_ROOT/coupling/SU2_PATO/runtime/run_persistent_coupling.sh"
check_file "$SU2_ROOT/coupling/SU2_PATO/runtime/run_pysu2.sh"
check_file "$SU2_ROOT/coupling/SU2_PATO/map_su2_profile_to_pato_faces.py"
check_file "$SU2_ROOT/coupling/SU2_PATO/map_pato_temperature_to_su2.py"

check_cmd python3
check_cmd SU2_CFD
check_cmd PATOx

if [[ -n "$PATO_DIR_ARG" ]]; then
  PATO_DIR_ARG="$(readlink -f "$PATO_DIR_ARG")"
  if [[ -d "$PATO_DIR_ARG" ]]; then echo "PASS PATO_DIR=$PATO_DIR_ARG"; else echo "FAIL PATO_DIR not found: $PATO_DIR_ARG"; fail=1; fi
  AIR11="$PATO_DIR_ARG/data/ThermoTransportChemistry/mutation++/mixtures/air_11.xml"
  if [[ -f "$AIR11" ]]; then echo "PASS Mutation++ air_11 data"; else echo "WARN air_11.xml not found at expected PATO data path"; fi
fi

python3 -m py_compile \
  "$SU2_ROOT/coupling/SU2_PATO/runtime/run_persistent_coupling.py" \
  "$SU2_ROOT/coupling/SU2_PATO/map_su2_profile_to_pato_faces.py" \
  "$SU2_ROOT/coupling/SU2_PATO/map_pato_temperature_to_su2.py" || fail=1

if [[ $fail -eq 0 ]]; then
  echo "SU2_PATO_DOCTOR=PASS"
else
  echo "SU2_PATO_DOCTOR=FAIL"
fi
exit "$fail"
