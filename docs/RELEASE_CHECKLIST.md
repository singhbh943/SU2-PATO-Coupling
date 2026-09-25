# Release checklist

Before creating a public GitHub release:

- [ ] `scripts/release_check.sh .` passes.
- [ ] No `/home/<user>` or site-specific absolute paths remain.
- [ ] No meshes, restart files, logs, result VTK/VTU files, private PATO cases, or material databases are committed.
- [ ] No conda environment or compiled solver binary is committed.
- [ ] `README.md` contains the actual GitHub repository URL.
- [ ] `CITATION.cff` has the actual author/repository metadata.
- [ ] The chosen repository license is confirmed by the copyright owner(s).
- [ ] Third-party notices are reviewed.
- [ ] Python source compiles and shell scripts pass `bash -n`.
- [ ] Installation is tested on a clean SU2 checkout/build environment.
- [ ] `doctor.sh` passes after installation.
- [ ] Interface validation is reproduced from clean cases.
- [ ] Physical-production claims are separated from software/interface validation claims.
- [ ] Version tag is created only after the above gates pass.
