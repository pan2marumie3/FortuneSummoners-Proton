# Licensing and attribution

This project builds an **unofficial** custom variant based on GE-Proton 11-9 for ARM64.

The top-level Proton license ([LICENSE.proton](./LICENSE.proton)) expressly allows redistribution and modification of source and binaries subject to attribution, license reproduction and non-endorsement requirements. GE-Proton and the Proton distribution comprise many independent components with their own terms; see [dist.LICENSE](./dist.LICENSE) and licenses bundled with the binary.

This repository includes a small patch for Wine's `winedmo` DirectShow parser. The modified Wine library is subject to the GNU Lesser General Public License 2.1 ([Wine-COPYING.LIB](./Wine-COPYING.LIB)). The applicable corresponding sources can be obtained from the following public, machine-readable repositories and the patch/build steps:

- GE-Proton 11-9 source tag: https://github.com/GloriousEggroll/proton-ge-custom/tree/GE-Proton11-9
- Wine pinned revision in GE-Proton 11-9: https://github.com/ValveSoftware/wine/tree/981e2f0b9007fd70a6e0ed6119cb18f4164e26f9
- GE-Proton staging/patch scripts and dependency pins: https://github.com/GloriousEggroll/proton-ge-custom/tree/GE-Proton11-9/patches
- This project's own Wine patch: https://github.com/pan2marumie3/FortuneSummoners-Proton/blob/main/patches/wma-loop-zero-seek.patch
- Build instructions (including exact GE tag and patch application): https://github.com/pan2marumie3/FortuneSummoners-Proton/blob/main/.github/workflows/build-arm64.yml

**Not an official GE-Proton, Valve Proton, Wine or DroidDeck release.** No endorsement, compatibility assurance or support from those projects is claimed.
