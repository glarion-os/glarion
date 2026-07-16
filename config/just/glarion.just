# Glarion just recipes
# Available via: ujust <recipe-name>
# List all recipes: ujust --list

# Install the Glarion demo Flatpaks
install-flatpaks:
    echo "Installing Glarion demo Flatpaks..."
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

# Roll back to previous OS version
rollback:
    echo "Rolling back to previous Glarion version..."
    rpm-ostree rollback

# Show OS status
status:
    rpm-ostree status

# Open Glarion issue tracker
feedback:
    xdg-open "https://github.com/glarion-os/glarion/issues"
