# Glarion

A polished Linux desktop OS that treats gaming as a first-class citizen.

Built on Fedora Kinoite. Designed for developers who also want to play games without fighting their OS.

---

## What it is

- **macOS-quality desktop experience** on Linux hardware
- **Gaming without friction** — Windows games run via Proton, no manual setup required
- **Developer-first** — terminal, Git, Node, Docker, SSH all work exactly as expected
- **Foundation-governed** — no single commercial entity controls the storefront, OS, and hardware simultaneously

## Reference hardware

**Minisforum UM790 Pro** (AMD Ryzen 9 7940HS / Radeon 780M)

All-AMD means all drivers are open source and upstream in the kernel. No driver headaches.

## Known display limitations

**4K120 over HDMI does not work on Linux for AMD hardware.** This is a Linux-wide limitation
(the HDMI Forum rejected AMD's open-source HDMI 2.1 implementation) and cannot be fixed at
the OS layer. 4K60 over HDMI works fine.

**Workaround for 4K120:** Use the front USB4 ports with a USB-C to USB-C cable directly to
a monitor with USB-C input, or a USB-C to DisplayPort cable. Avoid USB-C to HDMI adapters
unless you have confirmed they have updated firmware for Linux compatibility.

## Installation

> Requires: Secure Boot disabled in BIOS

### Try it live (recommended)

The live ISO boots a full Glarion session — desktop, Steam, the lot — straight
from a USB stick without touching your disks. Download and verify it:

```bash
curl -LO https://pub-27e8de4c5aa14382b04372b8f9be06a2.r2.dev/glarion-live.iso
curl -LO https://pub-27e8de4c5aa14382b04372b8f9be06a2.r2.dev/glarion-live.iso.sha256
sha256sum -c glarion-live.iso.sha256
```

Write it to a USB stick of at least 16 GB (**this erases the stick** — find
the device name with `lsblk`, or `diskutil list` on macOS):

```bash
sudo dd if=glarion-live.iso of=/dev/sdX bs=4M status=progress oflag=direct
```

Fedora Media Writer or balenaEtcher work too. Boot from the stick and try
Glarion; the session runs entirely from the USB stick and leaves the
machine's disks untouched.

### Fresh install (unattended)

For provisioning a machine hands-off, the installer ISO installs Glarion
without any interaction:

```bash
curl -LO https://pub-27e8de4c5aa14382b04372b8f9be06a2.r2.dev/glarion-installer.iso
curl -LO https://pub-27e8de4c5aa14382b04372b8f9be06a2.r2.dev/glarion-installer.iso.sha256
sha256sum -c glarion-installer.iso.sha256
```

Write it to a USB stick as above.

> **Warning:** the installer is unattended. Booting from the stick erases the
> machine's first disk and installs Glarion onto it without asking. Only boot
> it on a machine you intend to wipe.

The installed system runs the signed Glarion image and receives updates
automatically.

### From an existing Fedora Kinoite system

```bash
# From a running Fedora Kinoite system, rebase to Glarion:
rpm-ostree rebase ostree-unverified-registry:ghcr.io/glarion-os/glarion:latest
systemctl reboot

# Then switch to the signed image (the first rebase installs Glarion's
# signing key and policy; from here every update is signature-verified):
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/glarion-os/glarion:latest
systemctl reboot
```

## Updating

Glarion checks for updates in the background, downloads them, and stages them
automatically; the staged update applies the next time the machine reboots.
No commands, no prompts.

To check for and stage an update immediately instead of waiting:

```bash
just update
```

To roll back to the previous version:

```bash
just rollback
```

## Useful commands

```bash
just --list          # Show all available commands
just show-tdp        # Show current TDP configuration
just apply-tdp       # Re-apply TDP configuration manually
just gpu-info        # Show GPU status
just status          # Show OS version and update status
```

## Building from source

Requires [podman](https://podman.io). Docker will not work — the Kinoite base image exceeds Docker's overlay layer limit.

On macOS, set up a podman machine first (only needed once):

```bash
podman machine init --cpus 4 --memory 8192 --disk-size 100
podman machine start
```

Then build:

```bash
git clone https://github.com/glarion-os/glarion
cd glarion
podman build -f Containerfile -t glarion:local .
```

Pushes to main trigger an automatic build via GitHub Actions, published to
`ghcr.io/glarion-os/glarion`. A weekly scheduled build picks up upstream
Kinoite updates.

## Contributing

Issues and PRs welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## Licence

The Glarion configuration and build scripts are MIT licensed.
Components pulled from upstream projects retain their original licences.
