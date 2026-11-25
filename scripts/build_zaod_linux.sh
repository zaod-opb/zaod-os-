#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="${DIST:-bookworm}"
ARCH="${ARCH:-amd64}"
OUTPUT="${OUTPUT:-/workspaces/zaod-linux-output}"
WORK="${WORK:-/workspaces/zaod-linux-build}"
DESKTOP="${DESKTOP:-kde}"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Live ISO build ko root privileges chahiye." >&2
  exit 1
fi

command -v lb >/dev/null || {
  echo "Pehle ./scripts/install_linux_dependencies.sh chalain." >&2
  exit 1
}

mkdir -p "$WORK" "$OUTPUT"
cd "$WORK"
lb clean --purge >/dev/null 2>&1 || true

lb config \
  --distribution "$DIST" \
  --architecture "$ARCH" \
  --binary-images iso-hybrid \
  --debian-installer live \
  --bootappend-live "boot=live username=zaod components quiet splash" \
  --apt-indices false \
  --apt-recommends true \
  --mirror-bootstrap "http://deb.debian.org/debian/" \
  --mirror-chroot "http://deb.debian.org/debian/" \
  --mirror-binary "http://deb.debian.org/debian/" \
  --mirror-chroot-security "http://deb.debian.org/debian-security/" \
  --mirror-binary-security "http://deb.debian.org/debian-security/" \
  --archive-areas "main contrib non-free non-free-firmware"

cat > config/package-lists/zaod.list.chroot <<EOF
chromium
firefox-esr
calamares-settings-debian
calamares
network-manager
network-manager-gnome
sudo
plymouth
plymouth-themes
linux-image-amd64
EOF

if [[ "$DESKTOP" == "kde" ]]; then
  cat >> config/package-lists/zaod.list.chroot <<EOF
plasma-desktop
plasma-nm
konsole
dolphin
systemsettings
EOF
else
  cat >> config/package-lists/zaod.list.chroot <<EOF
xfce4
xfce4-goodies
lightdm
EOF
fi

mkdir -p config/includes.chroot/etc/zaod
cp -a "$ROOT/branding/." config/includes.chroot/etc/zaod/

lb build

ISO="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [[ -n "$ISO" ]]; then
  cp -f "$ISO" "$OUTPUT/ZAOD-Linux-$DIST-$ARCH.iso"
  sha256sum "$OUTPUT/ZAOD-Linux-$DIST-$ARCH.iso" > "$OUTPUT/ZAOD-Linux-$DIST-$ARCH.iso.sha256"
fi
