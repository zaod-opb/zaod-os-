#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ASSETS="$ROOT/branding/assets"

command -v npm >/dev/null || {
  echo "NPM required for Material 3 font aur Lucide icon assets." >&2
  exit 1
}

mkdir -p "$ASSETS/fonts" "$ASSETS/icons"
cd "$ASSETS"
mkdir -p "$ROOT/branding/licenses"

npm pack @fontsource/outfit@latest --silent
npm pack @fontsource/roboto@latest --silent
npm pack lucide-static@latest --silent

for archive in fontsource-outfit-*.tgz fontsource-roboto-*.tgz lucide-static-*.tgz; do
  [[ -e "$archive" ]] || continue
  case "$archive" in
    fontsource-outfit-*)
      tar -xzf "$archive" --strip-components=2 -C fonts package/files
      tar -xOzf "$archive" package/LICENSE > "$ROOT/branding/licenses/Outfit.txt"
      ;;
    fontsource-roboto-*)
      tar -xzf "$archive" --strip-components=2 -C fonts package/files
      tar -xOzf "$archive" package/LICENSE > "$ROOT/branding/licenses/Roboto.txt"
      ;;
    lucide-static-*)
      tar -xzf "$archive" --strip-components=2 -C icons package
      tar -xOzf "$archive" package/LICENSE > "$ROOT/branding/licenses/Lucide.txt"
      ;;
  esac
done

rm -f ./*.tgz
