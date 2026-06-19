#!/bin/bash
# install-flatpaks.sh
# Installs default Flatpaks for Glarion
# This runs at first boot or can be triggered manually via:
#   just install-flatpaks

set -euo pipefail

echo "Glarion: Installing default Flatpaks..."

# Ensure Flathub is configured
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

FLATPAKS=(
    # Gaming
    "com.valvesoftware.Steam"                    # Steam
    "com.heroicgameslauncher.hgl"                # Heroic (Epic/GOG)
    "net.lutris.Lutris"                          # Lutris
    "com.github.tchx84.Flatseal"                 # Flatpak permissions manager

    # Browser
    "org.mozilla.firefox"                        # Firefox

    # Development
    "com.visualstudio.code"                      # VS Code
    "io.podman_desktop.PodmanDesktop"            # Podman Desktop
    "rest.insomnia.Insomnia"                     # API client

    # Productivity
    "org.gnome.seahorse.Application"             # Keyring manager
    "org.kde.kcalc"                              # Calculator
    "org.kde.gwenview"                           # Image viewer

    # Media
    "org.videolan.VLC"                           # VLC
    "com.spotify.Client"                         # Spotify
)

for FLATPAK in "${FLATPAKS[@]}"; do
    # Skip comments
    [[ "$FLATPAK" == \#* ]] && continue
    [[ -z "$FLATPAK" ]] && continue

    echo "  Installing ${FLATPAK}..."
    flatpak install -y --noninteractive flathub "${FLATPAK}" || {
        echo "  Warning: Failed to install ${FLATPAK}, continuing..."
    }
done

echo "Glarion: Default Flatpaks installed."
