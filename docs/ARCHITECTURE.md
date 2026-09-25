# Architecture

## Persistent solver ownership

The PySU2 driver is created once and finalized once. Between exchanges the solver state is advanced using the supported PySU2 lifecycle rather than recreating the solver from disk.

PATO persistence is disk-based: each material solve starts from the latest written PATO time directory and advances by the configured material time increment.

## SU2 → PATO transfer

SU2 wall-normal heat flux is retrieved directly from the PySU2 marker API. The wall profile is ordered geometrically and conservatively integrated onto the PATO face discretization. The implementation checks the source and target integrated heat loads.

## PATO → SU2 transfer

The PATO wall-face temperature field is read from the material boundary and mapped to the SU2 wall vertices. Endpoint handling and coordinate-ordering assumptions must remain consistent with the physical interface.

## Sign convention

For the validated configuration, positive SU2 wall heating is mapped with the same numerical sign to the PATO heat-flux boundary. The runtime source contains the implementation-specific sign rationale. Users modifying boundary orientation or PATO boundary-condition type must revalidate the convention.
