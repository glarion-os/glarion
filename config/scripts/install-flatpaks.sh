#!/bin/bash
# install-flatpaks.sh
# Installs default Flatpaks for Glarion
# This runs at first boot or can be triggered manually via:
#   just install-flatpaks

set -euo pipefail

echo "Glarion: Installing default Flatpaks..."

# Ensure Flathub is configured
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# The list lives in /usr/share/glarion/flatpaks.list (config/flatpaks.list in
# the repo) and is shared with the live ISO build.
FLATPAKS_LIST="/usr/share/glarion/flatpaks.list"

while IFS= read -r FLATPAK; do
    [[ -z "$FLATPAK" ]] && continue

    echo "  Installing ${FLATPAK}..."
    flatpak install -y --noninteractive flathub "${FLATPAK}" || {
        echo "  Warning: Failed to install ${FLATPAK}, continuing..."
    }
done < "$FLATPAKS_LIST"

echo "Glarion: Default Flatpaks installed."
