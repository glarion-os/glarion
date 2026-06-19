#!/bin/bash
# ryzenadj-setup.sh
# TDP configuration for AMD Ryzen 9 7940HS (Minisforum UM790 Pro)
# 
# The 7940HS has a configurable TDP range.
# These values represent a balanced desktop profile.
# Adjust based on your preference: lower = cooler/quieter, higher = more performance.
#
# Values are in milliwatts.

# Sustained Power Limit (STAPM) - long-term average TDP
STAPM_LIMIT=45000       # 45W

# Actual Power Limit - short-term boost ceiling
PPT_LIMIT_FAST=65000    # 65W burst

# Slow Power Limit - medium-term average
PPT_LIMIT_SLOW=50000    # 50W

# Thermal headroom before throttling (degrees C from Tctl max)
TCTL_TEMP=95

# VRM current limits (leave high to avoid artificial current throttling)
VRM_CURRENT=300000      # 300A
VRM_MAX_CURRENT=300000  # 300A
VRM_SOC_CURRENT=200000  # 200A

# Check ryzenadj is available
if ! command -v ryzenadj &>/dev/null; then
    echo "ryzenadj not found, skipping TDP configuration"
    exit 0
fi

ryzenadj \
    --stapm-limit=${STAPM_LIMIT} \
    --fast-limit=${PPT_LIMIT_FAST} \
    --slow-limit=${PPT_LIMIT_SLOW} \
    --tctl-temp=${TCTL_TEMP} \
    --vrm-current=${VRM_CURRENT} \
    --vrmmax-current=${VRM_MAX_CURRENT} \
    --vrmsoc-current=${VRM_SOC_CURRENT}

if [ $? -eq 0 ]; then
    echo "Glarion: TDP configuration applied successfully"
    echo "  STAPM: ${STAPM_LIMIT}mW | Fast: ${PPT_LIMIT_FAST}mW | Slow: ${PPT_LIMIT_SLOW}mW"
else
    echo "Glarion: ryzenadj failed - BIOS may not expose the required interface"
    echo "  This is non-fatal, default TDP limits will apply"
fi
