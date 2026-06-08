#!/bin/bash
set -euxo pipefail

# Politique bioconda/conda-forge : embarquer les licences de toutes les
# dépendances Rust. Génère THIRDPARTY.yml dans $SRC_DIR, référencé par
# license_file dans meta.yaml.
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

# --locked   : build contre le Cargo.lock committé (reproductibilité clinique)
# --no-track : pas de receipt d'install, prefix propre
# installe les DEUX binaires déclarés (nasvar, aggregate) dans $PREFIX/bin
cargo install --locked --no-track --root "$PREFIX" --path .
