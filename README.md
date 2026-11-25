# ZAOD OS

ZAOD OS open-source ChromiumOS base par banne wali ek professional desktop operating system variant hai. ChromeOS proprietary image ki bajaye, build ChromiumOS ke open-source source se kiya jayega.

## ZAOD Linux desktop track

Agar ChromiumOS/Crostini environment build ke native chroot ko restrict karta hai, to ZAOD OS ko Debian 12 based live desktop image ke roop me bhi build kiya jayega:

- Open-source KDE Plasma ya XFCE desktop
- Original ZAOD Material-3-inspired design
- Google Fonts ke open-source families
- Lucide MIT icons
- Chromium aur Firefox
- Debian 12 repositories ke latest available packages

Debian ka default kernel stable aur security-supported hota hai. Exact latest upstream kernel use karne ke liye separate kernel build/configuration ki zaroorat hoti hai; woh proprietary ISO ke liye nahi aur security/performance testing ke baad add kiya jayega.

### Linux ISO build

```bash
./scripts/install_linux_dependencies.sh
sudo ./scripts/build_zaod_linux.sh
```

Official font aur Lucide assets download karne ke liye:

```bash
./scripts/fetch_design_assets.sh
```

Linux image output:

```text
/workspaces/zaod-linux-output/ZAOD-Linux-bookworm-amd64.iso
```

## GitHub Actions build

GitHub Actions workflow ko `Actions` tab se `Build ZAOD Linux ISO` run karke start kiya ja sakta hai. Public repository me runner usage free tier ki limits ke andar rehta hai. Workflow Ubuntu runner par dependencies install karke ZAOD ISO banata aur downloadable `ZAOD-Linux-bookworm-amd64` artifact upload karta hai.

## Zaruri baat

- ChromiumOS source build ke liye high-spec Linux host recommended hai:
  - 64 GB RAM ya zyada
  - kam az kam 200 GB free disk
  - 8 ya zyada CPU cores
- Ubuntu 22.04/24.04 aur x86-64 host sab se suitable hai.
- `amd64-generic` prototype build ke liye use hota hai. Uske baad real hardware ke liye board/configuration alag se customize hoti hai.

## Pehla setup

```bash
./scripts/install_build_dependencies.sh
./scripts/bootstrap_chromiumos.sh
```

Yeh commands ChromiumOS manifest initialize karti hain aur source ko local workspace me download karti hain:

```bash
SYNC_SOURCE=1 JOBS=8 ./scripts/bootstrap_chromiumos.sh
```

Source download aur first build lamba ho sakta hai aur internet/Disk requirements bahut high hain.

## ZAOD OS build

```bash
BOARD=amd64-generic ./scripts/build_zaod_os.sh
```

Built test image:

```text
/workspaces/chromiumos/src/build/images/amd64-generic/latest/chromiumos_test_image.bin
```

## Customization

ZAOD OS ke branding, boot logo, default apps, policies, aur first-run experience ko ChromiumOS overlays/packages ke through apply kiya jayega. Niche files baad me board-specific overlays aur policy templates ke liye reserve hain.