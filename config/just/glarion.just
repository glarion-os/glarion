# Glarion just recipes
# Available via: just <recipe-name>
# List all recipes: just --list

# Install default Flatpaks
install-flatpaks:
    echo "Installing Glarion default Flatpaks..."
    /usr/local/bin/glarion-install-flatpaks.sh

# Show current TDP configuration
show-tdp:
    echo "Current TDP configuration:"
    ryzenadj --info 2>/dev/null || echo "ryzenadj not available or requires root"

# Apply TDP configuration manually (useful after suspend if service missed it)
apply-tdp:
    echo "Applying TDP configuration..."
    sudo /usr/local/bin/ryzenadj-setup.sh

# Show GPU information
gpu-info:
    echo "=== AMD GPU Info ==="
    cat /sys/class/drm/card*/device/vendor 2>/dev/null || true
    echo ""
    echo "=== GPU Power ==="
    cat /sys/class/drm/card*/device/power_dpm_state 2>/dev/null || true
    cat /sys/class/drm/card*/device/power_dpm_force_performance_level 2>/dev/null || true

# Update the OS (pulls latest OCI image, applies on reboot)
update:
    echo "Checking for Glarion updates..."
    rpm-ostree update

# Roll back to previous OS version
rollback:
    echo "Rolling back to previous Glarion version..."
    rpm-ostree rollback

# Show OS status
status:
    rpm-ostree status

# Open Glarion issue tracker
feedback:
    xdg-open "https://gitlab.com/glarion/glarion/-/issues"
