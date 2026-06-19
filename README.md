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

```bash
# From a running Fedora Kinoite system, rebase to Glarion:
rpm-ostree rebase ostree-image-signed:docker://registry.gitlab.com/glarion/glarion:latest

# Reboot to apply
systemctl reboot
```

## Updating

Updates apply automatically on reboot. To check for and stage an update manually:

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
git clone https://gitlab.com/glarion/glarion
cd glarion
podman build -f Containerfile -t glarion:local .
```

Pushes to main trigger an automatic build via GitLab CI.

## Contributing

Issues and PRs welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## Licence

The Glarion configuration and build scripts are MIT licensed.
Components pulled from upstream projects retain their original licences.
