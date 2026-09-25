# Installation

## 1. Install upstream solvers

Install and validate SU2 (including PySU2/NEMO support) and PATO independently. This repository intentionally does not vendor either solver.

## 2. Clone the coupling repository

```bash
git clone https://github.com/singhbh943/SU2-PATO-Coupling.git
cd SU2-PATO-Coupling
```

## 3. Install into an SU2 source tree

```bash
./scripts/install_into_su2.sh --su2-root /path/to/SU2
```

## 4. Validate the environment

Activate the same PATO/OpenFOAM/Mutation++ environment used by your PATO installation, then run:

```bash
./scripts/doctor.sh \
  --su2-root /path/to/SU2 \
  --pato-dir /path/to/PATO
```

## 5. Prepare cases

The coupling layer does not create a complete physical case. Users must provide validated SU2 and PATO cases whose wall interfaces represent the same physical curve and use compatible boundary conditions.

Do not begin with production heat flux. First validate counts, coordinates, sign convention, conservative transfer, solver persistence, and temperature feedback using a conservative test configuration.
