# Contributing

Contributions are welcome through pull requests.

Please keep changes focused and reproducible:

1. Do not add meshes, restart files, full simulation outputs, private case data, conda environments, or upstream solver binaries.
2. Keep SU2/PATO paths configurable; never commit developer-specific absolute paths.
3. Run `scripts/release_check.sh .` before submitting a pull request.
4. Add or update tests when changing mapping, runtime checks, or coupling-state advancement.
5. Clearly distinguish interface/software validation from physical validation in documentation and pull requests.
