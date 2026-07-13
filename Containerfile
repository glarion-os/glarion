# Glarion OS
# Built on Fedora Kinoite (KDE Plasma, immutable, OCI-based)
# Reference hardware: Minisforum UM790 Pro (AMD Ryzen 9 7940HS / Radeon 780M)

ARG FEDORA_MAJOR_VERSION=44
ARG BASE_IMAGE="ghcr.io/ublue-os/kinoite-main"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

# ---------------------------------------------------------------------------
# Labels
# ---------------------------------------------------------------------------
LABEL org.opencontainers.image.title="Glarion"
LABEL org.opencontainers.image.description="A polished Linux desktop OS with first-class gaming support"
LABEL org.opencontainers.image.source="https://github.com/glarion-os/glarion"

# ---------------------------------------------------------------------------
# Remove Kinoite defaults we don't want
# ---------------------------------------------------------------------------
RUN rpm-ostree override remove \
    plasma-welcome \
    || true

# ---------------------------------------------------------------------------
# Add RPM repositories
# ---------------------------------------------------------------------------

RUN rpm-ostree install \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    && rpm-ostree cleanup -m

RUN dnf5 -y copr enable ublue-os/bazzite

# ---------------------------------------------------------------------------
# Install packages
# ---------------------------------------------------------------------------
RUN dnf5 -y install \
    ryzenadj \
    corectrl \
    lm_sensors \
    mangohud \
    gamescope \
    vkbasalt \
    gamemode \
    wine \
    winetricks \
    git \
    git-lfs \
    neovim \
    htop \
    fastfetch \
    ntfs-3g \
    exfatprogs \
    openssh \
    && dnf5 clean all

# ---------------------------------------------------------------------------
# Copy config files into the image
# ---------------------------------------------------------------------------

# AMD GPU kernel module configuration
COPY config/files/etc/modprobe.d/amdgpu.conf /etc/modprobe.d/amdgpu.conf

# Kernel arguments (preempt=voluntary for desktop/gaming latency)
COPY config/files/usr/lib/bootc/kargs.d/glarion.toml /usr/lib/bootc/kargs.d/glarion.toml

# ryzenadj systemd service (sets TDP on boot)
COPY config/files/etc/systemd/system/ryzenadj.service /etc/systemd/system/ryzenadj.service
COPY config/scripts/ryzenadj-setup.sh /usr/local/bin/ryzenadj-setup.sh
RUN chmod +x /usr/local/bin/ryzenadj-setup.sh

# ---------------------------------------------------------------------------
# Enable systemd services
# ---------------------------------------------------------------------------
RUN systemctl enable ryzenadj.service

# ---------------------------------------------------------------------------
# Flatpak demo set (preloaded on the live ISO; manual via just install-flatpaks)
# Installed systems ship without preinstalled apps by design.
# ---------------------------------------------------------------------------
COPY config/flatpaks.list /usr/share/glarion/flatpaks.list
COPY config/scripts/install-flatpaks.sh /usr/local/bin/glarion-install-flatpaks.sh
RUN chmod +x /usr/local/bin/glarion-install-flatpaks.sh

# ---------------------------------------------------------------------------
# just recipes (maintenance/utility commands available to the user)
# ---------------------------------------------------------------------------
COPY config/just/glarion.just /usr/share/ublue-os/just/60-glarion.just

# ---------------------------------------------------------------------------
# Image signature verification — updates must be signed with the Glarion key
# ---------------------------------------------------------------------------
COPY cosign.pub /etc/pki/containers/glarion.pub
COPY config/files/etc/containers/policy.json /etc/containers/policy.json
COPY config/files/etc/containers/registries.d/glarion.yaml /etc/containers/registries.d/glarion.yaml

# ---------------------------------------------------------------------------
# Finalise
# ---------------------------------------------------------------------------
RUN rpm-ostree cleanup -m \
    && ostree container commit
