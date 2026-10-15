#!/usr/bin/env bash
# Preserve the tested Proton executables while adding license documentation
# to the distribution archive, then simplify v0.1.0 Release assets.
set -euo pipefail

name="GE-Proton11-9-WMA-Loop-aarch64"
tag="v0.1.0"
temp="$(mktemp -d)"
trap 'rm -rf "$temp"' EXIT
mkdir -p "$temp/original" "$temp/repacked" "$temp/supplement"

for p in third_party/LICENSE.proton third_party/dist.LICENSE third_party/Wine-COPYING.LIB third_party/NOTICE.md patches/wma-loop-zero-seek.patch RELEASE_NOTES_v0.1.0.md; do
  test -s "$p"
done

gh release download "$tag" --repo "$GITHUB_REPOSITORY" \
  --pattern "$name.tar.gz" --pattern "$name.sha512sum" --dir "$temp/original"
(cd "$temp/original" && sha512sum -c "$name.sha512sum")
tar -tzf "$temp/original/$name.tar.gz" > "$temp/old-members.txt"
root="$(awk -F/ '$NF=="toolmanifest.vdf" {print $1; exit}' "$temp/old-members.txt")"
test "$root" = "$name" || { echo "Unexpected Proton root directory: $root" >&2; exit 1; }

mkdir -p "$temp/supplement/$root"
cp third_party/LICENSE.proton "$temp/supplement/$root/LICENSE.proton"
cp third_party/dist.LICENSE "$temp/supplement/$root/dist.LICENSE"
cp third_party/Wine-COPYING.LIB "$temp/supplement/$root/Wine-COPYING.LIB"
cp third_party/NOTICE.md "$temp/supplement/$root/SOURCE-AND-LICENSES.md"
cp patches/wma-loop-zero-seek.patch "$temp/supplement/$root/wma-loop-zero-seek.patch"

required=(LICENSE.proton dist.LICENSE Wine-COPYING.LIB SOURCE-AND-LICENSES.md wma-loop-zero-seek.patch)
append=()
for file in "${required[@]}"; do
  if ! grep -Fxq "$root/$file" "$temp/old-members.txt"; then
    append+=("$root/$file")
  fi
done

if (( ${#append[@]} > 0 )); then
  echo "Adding documentation to archive: ${append[*]}"
  gzip -dc "$temp/original/$name.tar.gz" > "$temp/old.tar"
  tar -rf "$temp/old.tar" -C "$temp/supplement" "${append[@]}"
  gzip -6 -c "$temp/old.tar" > "$temp/repacked/$name.tar.gz"
  (cd "$temp/repacked" && sha512sum "$name.tar.gz" > "$name.sha512sum" && sha512sum -c "$name.sha512sum")
  tar -tzf "$temp/repacked/$name.tar.gz" > "$temp/new-members.txt"
  for file in "${required[@]}"; do
    grep -Fxq "$root/$file" "$temp/new-members.txt"
  done
  tar -xOf "$temp/repacked/$name.tar.gz" "$root/LICENSE.proton" | cmp - third_party/LICENSE.proton
  tar -xOf "$temp/repacked/$name.tar.gz" "$root/dist.LICENSE" | cmp - third_party/dist.LICENSE
  tar -xOf "$temp/repacked/$name.tar.gz" "$root/Wine-COPYING.LIB" | cmp - third_party/Wine-COPYING.LIB
  echo "Documentation added; original executables were not modified."
  gh release upload "$tag" "$temp/repacked/$name.tar.gz" "$temp/repacked/$name.sha512sum" \
    --repo "$GITHUB_REPOSITORY" --clobber
else
  echo "Release archive already contains the required documentation."
fi

# Only remove visible duplicates once all notices are available inside the tarball.
gh release edit "$tag" --repo "$GITHUB_REPOSITORY" --notes-file RELEASE_NOTES_v0.1.0.md
for asset in SOURCE-AND-LICENSES.md UPSTREAM-dist.LICENSE UPSTREAM-LICENSE.proton Wine-LGPL-2.1.txt wma-loop-zero-seek.patch; do
  if gh release view "$tag" --repo "$GITHUB_REPOSITORY" --json assets --jq '.assets[].name' | grep -Fxq "$asset"; then
    gh release delete-asset "$tag" "$asset" --repo "$GITHUB_REPOSITORY" --yes
  fi
done

actual="$(gh release view "$tag" --repo "$GITHUB_REPOSITORY" --json assets --jq '.assets[].name' | LC_ALL=C sort)"
expected="$(printf '%s\n' "$name.sha512sum" "$name.tar.gz" | LC_ALL=C sort)"
printf 'Final release assets:\n%s\n' "$actual"
test "$actual" = "$expected"
echo "Release organized successfully."
