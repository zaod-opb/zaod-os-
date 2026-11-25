#!/usr/bin/env bash
set -euo pipefail

CHROMIUMOS_DIR="${CHROMIUMOS_DIR:-/workspaces/chromiumos}"
JOBS="${JOBS:-$(nproc)}"
SYNC_SOURCE="${SYNC_SOURCE:-0}"

if [[ ! -d /workspaces ]]; then
  echo "Ye script Ubuntu/Linux build host ke liye hai." >&2
  exit 1
fi

mkdir -p "$CHROMIUMOS_DIR"
cd "$CHROMIUMOS_DIR"

mkdir -p .repo
if [[ ! -x "$CHROMIUMOS_DIR/repo" ]]; then
  curl -fL https://storage.googleapis.com/git-repo-downloads/repo -o repo
  chmod +x repo
fi

git config --global user.name "ZAOD OS Builder" || true
git config --global user.email "builder@zaodos.local" || true

./repo init \
  --manifest-url=https://chromium.googlesource.com/chromiumos/manifest \
  --manifest-name=default.xml \
  --repo-url=https://chromium.googlesource.com/external/repo

echo "ChromiumOS manifest initialized at: $CHROMIUMOS_DIR"

if [[ "$SYNC_SOURCE" == "1" ]]; then
  echo "ChromiumOS source download start ho raha hai..."
  ./repo sync -j"$JOBS" --current-branch --no-tags
fi
