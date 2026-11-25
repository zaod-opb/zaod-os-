#!/usr/bin/env bash
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  SUDO="sudo"
else
  SUDO=""
fi

$SUDO apt-get update
$SUDO apt-get install -y \
  debootstrap live-build isolinux syslinux-common grub-pc-bin grub-efi-amd64-bin \
  xorriso squashfs-tools mtools dosfstools rsync curl wget git xz-utils \
  python3 python3-pip plymouth plymouth-themes \
  debian-archive-keyring debian-keyring
