#!/bin/bash
set -euxo pipefail

# bioconda/conda-forge policy: bundle the licenses of all Rust
# dependencies. Generates THIRDPARTY.yml in $SRC_DIR, referenced by
# license_file in meta.yaml.
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

# --locked   : build against the committed Cargo.lock (clinical reproducibility)
# --no-track : no install receipt, clean prefix
# installs BOTH declared binaries (nasvar, aggregate) into $PREFIX/bin
cargo install --locked --no-track --root "$PREFIX" --path .
