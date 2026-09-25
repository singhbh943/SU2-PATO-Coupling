# SU2–PATO Two-Way Coupling

A lightweight coupling layer for exchanging wall heat flux and wall temperature between **SU2 NEMO** and **NASA PATO**.

The coupling is intentionally distributed separately from SU2 and PATO. Users install both upstream solvers independently, then install this coupling layer into an SU2 source tree.

## Coupling algorithm

For each coupling exchange:

1. Apply the current PATO wall-temperature field to the SU2 Python-custom wall boundary.
2. Advance the persistent PySU2 solver state.
3. Read wall-normal heat flux directly from the PySU2 API.
4. Conservatively map SU2 wall-vertex heat flux to PATO boundary faces.
5. Apply the configured heat-flux scale and install the flux on the PATO wall.
6. Advance PATO from `latestTime` by the configured material time step.
7. Map PATO wall-face temperature back to SU2 wall vertices.
8. Repeat without reconstructing the PySU2 driver between exchanges.

The mapping preserves the integrated wall heat load along the interface to numerical precision when source and target interfaces represent the same curve.

## Requirements

- Linux
- A working SU2 build with PySU2/NEMO support
- PATO with its compatible OpenFOAM environment
- Mutation++ data required by the selected gas mixture
- Python 3.9+

Upstream projects are **not bundled** with this repository.

## Install into SU2

```bash
./scripts/install_into_su2.sh --su2-root /path/to/SU2
```

This installs the coupling layer at:

```text
/path/to/SU2/coupling/SU2_PATO
```

The installer refuses to overwrite an existing installation unless `--force` is provided.

## Verify installation

```bash
./scripts/doctor.sh --su2-root /path/to/SU2 --pato-dir /path/to/PATO
```

## Case requirements

### SU2

The wall marker used by the coupling must be exposed to the Python interface, for example:

```text
MARKER_PYTHON_CUSTOM= ( wall )
```

For NEMO restart-based coupling, the case must also provide the mesh, restart solution, thermochemical model, and catalytic-wall settings required by the intended simulation.

### PATO

The coupled boundary must use a flux boundary condition compatible with PATO's `basicWallHeatFluxTemperature`, e.g. a `mode flux` wall with a nonuniform `q` list. The PATO case should use `startFrom latestTime` for persistent material-state advancement. High write precision is strongly recommended for very small coupling steps.

See `examples/AIR11_M23p9/` for configuration fragments only. The example deliberately does not contain proprietary/private meshes, restart files, material databases, or result data.

## Scientific validation

Before production use, validate at minimum:

- SU2 wall vertex count and coordinates
- PATO wall face count and ordering
- conservative heat-load mapping
- heat-flux sign convention
- wall-temperature feedback sensitivity
- persistence of the PySU2 state across exchanges
- persistence of the PATO state through `latestTime`
- stability for the intended physical heat flux and material time step

The small `Q_SCALE` and very small PATO time steps often used during software/interface validation are not substitutes for a physically justified production configuration.

## Third-party software

See `THIRD_PARTY_NOTICES.md`. This repository does not redistribute SU2, PATO, OpenFOAM, Mutation++, or their datasets.

## Citation

If you use this coupling layer in academic work, see `CITATION.cff` and replace the placeholder repository DOI/URL after the first public release.
