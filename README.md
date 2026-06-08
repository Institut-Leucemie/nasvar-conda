# nasvar-conda

Conda recipe for [nasvar](https://github.com/jwanglab/nasvar) — *Nanopore Adaptive
Sampling VARiant caller* — packaged for reproducible, version-locked deployment as a
[Galaxy](https://galaxyproject.org) tool dependency in non-commercial clinical-research
settings.

This repository contains **build instructions only**. It does not contain, vendor, or
redistribute nasvar itself.

## Why this repository (and why not Bioconda)

nasvar is distributed by its authors under the UNC non-commercial license (Ref. 24-0059).
Bioconda requires that distributed packages permit redistribution: the channel, and the
BioContainers images derived from it, are used broadly — including by commercial users.
nasvar is therefore not eligible for the main Bioconda channel.

This repository provides the recipe that would otherwise be the Bioconda submission, so
that nasvar can be built and deployed reproducibly — version-locked and auditable —
within non-commercial environments. It is the missing, inspectable link between the
upstream source and an installed Galaxy tool.

## The packaging chain

```
  jwanglab/nasvar  @ v1.1.0          upstream source (UNC non-commercial license)
          │
          │   pinned by sha256 in recipe/meta.yaml      ← root of trust
          ▼
  recipe/   (this repository — GPL3)   build instructions, no binary
          │
          │   conda build recipe/
          ▼
  nasvar-<version>-*.conda            local artifact — never redistributed
          │
          │   served via a local conda channel
          ▼
  Galaxy  <requirement type="package">nasvar</requirement>
          │
          │   resolved with conda_use_local: true
          ▼
  nasvar tool, version-locked, in the Galaxy server
```

Every link is inspectable: the recipe pins the exact upstream release by `sha256`, the
build is reproducible from source on any machine, and the resulting artifact is
version-locked.

## Building the package

Prerequisites: `conda` and `conda-build` (e.g. from [Miniforge](https://github.com/conda-forge/miniforge)).

```bash
git clone https://github.com/Institut-Leucemie/nasvar-conda
cd nasvar-conda
conda build recipe/
```

`conda-build` creates an isolated environment, pulls the Rust toolchain and compilers from
conda-forge (as declared in the recipe), downloads the pinned upstream source, compiles
nasvar from it, runs the test phase, and writes the artifact to:

```
<conda-root>/conda-bld/linux-64/nasvar-<version>-*.conda
```

Expect a few minutes for the Rust + jemalloc compilation. The build verifies the
downloaded source against the `sha256` pinned in `recipe/meta.yaml`; a mismatch aborts the
build by design.

## Using it in Galaxy

The built artifact is consumed through a **local** conda channel — never published. On a
Galaxy server with `conda_use_local: true`, a tool wrapper declaring

```xml
<requirement type="package" version="...">nasvar</requirement>
```

resolves against the locally built artifact exactly as it would against Bioconda. The
companion Galaxy wrapper lives in
[nasvar-galaxy-wrapper](https://github.com/Institut-Leucemie/nasvar-galaxy-wrapper).

## Licensing — two distinct licenses

- **This repository** (the recipe: `meta.yaml`, `build.sh`, `conda_build_config.yaml`) is
  released under the **MIT license**. The recipe is original work and is free to reuse.
- **nasvar itself** is under the **UNC non-commercial license (Ref. 24-0059)**, declared
  in the `license:` field of `recipe/meta.yaml`. This recipe does not contain or
  redistribute nasvar — it builds it from the upstream source at build time. The compiled
  `.conda` artifact is a non-commercial binary intended for internal, non-commercial use
  and is **not** redistributed from this repository.

A permissive recipe that builds non-commercially-licensed software is standard practice:
many Bioconda recipes carry a license different from the software they package.

## Related

- Upstream source — [jwanglab/nasvar](https://github.com/jwanglab/nasvar)
- Galaxy wrapper — [Institut-Leucemie/nasvar-galaxy-wrapper](https://github.com/Institut-Leucemie/nasvar-galaxy-wrapper)
