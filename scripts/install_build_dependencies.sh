#!/usr/bin/env bash
set -euo pipefail

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y \
    git gitk curl python3 python3-pip python-is-python3 \
    rsync gnupg wget ca-certificates
else
  echo "Ubuntu/Debian-based build host required." >&2
  exit 1
fi
