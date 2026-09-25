# Changelog

All notable changes to this project will be documented here.

## [Unreleased]

## [0.1.0] - 2026-09-26

### Added
- Persistent PySU2 ↔ PATO two-way coupling runtime.
- Conservative SU2 wall-vertex to PATO face heat-flux mapping.
- PATO face-temperature to SU2 wall-vertex mapping.
- Persistent PySU2 state update between coupling exchanges.
- PATO `latestTime` advancement.
- Explicit heat-flux sign-convention documentation.
- Runtime checks for wall count, finite values, coordinate mapping, and conservative heat-load transfer.
- Installation, doctor, CI, and release-preparation tooling.

### Fixed
- Resolve interface reference paths after runtime argument parsing, so `--work` correctly selects the reference profile and face files.
