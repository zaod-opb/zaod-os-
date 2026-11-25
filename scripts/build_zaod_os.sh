#!/usr/bin/env bash
set -euo pipefail

CHROMIUMOS_DIR="${CHROMIUMOS_DIR:-/workspaces/chromiumos}"
BOARD="${BOARD:-amd64-generic}"

if [[ ! -d "$CHROMIUMOS_DIR/.repo" ]]; then
  echo "Pehle scripts/bootstrap_chromiumos.sh chalain." >&2
  exit 1
fi

cd "$CHROMIUMOS_DIR"

if [[ ! -d src ]]; then
  echo "ChromiumOS source abhi synced nahi hai. SYNC_SOURCE=1 ke sath bootstrap chalain." >&2
  exit 1
fi

echo "ZAOD OS ChromiumOS build: board=$BOARD"
./chromite/bin/cros_sdk --enter <<EOF
export BOARD=$BOARD
./setup_board --board=\$BOARD --force
./build_packages --board=\$BOARD
./build_image --board=\$BOARD test
EOF

echo "Latest image:"
find "src/build/images/$BOARD" -maxdepth 2 -type f \
  -name '*chromiumos*.bin' -printf '%p\n' | sort
