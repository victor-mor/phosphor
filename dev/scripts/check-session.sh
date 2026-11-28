#!/usr/bin/env bash
# Check development services and the fixture inside the container.
# Inputs: none. Output: per-check status; exits 1 if any check fails.
set -uo pipefail

# Run every service check even if an earlier one fails.
failed=0
if wpctl status >/dev/null 2>&1; then
    echo 'wpctl: OK'
else
    echo 'wpctl: FAIL'
    failed=1
fi
if pactl info >/dev/null 2>&1; then
    echo 'pactl: OK'
else
    echo 'pactl: FAIL'
    failed=1
fi
if nmcli general >/dev/null 2>&1; then
    echo 'nmcli: OK'
else
    echo 'nmcli: FAIL'
    failed=1
fi

# Query the nested instance rather than an inherited parent instance.
export XDG_RUNTIME_DIR=/tmp/phosphor-dev/xdg
instances=$(env -u HYPRLAND_INSTANCE_SIGNATURE hyprctl -j instances 2>/dev/null || true)
instance=$(grep -oP '"instance"\s*:\s*"\K[^"]+' <<< "$instances" | head -1 || true)
clients=''
if [[ -n $instance ]]; then
    clients=$(HYPRLAND_INSTANCE_SIGNATURE=$instance hyprctl clients 2>/dev/null || true)
fi
# A running process alone does not prove that the fixture window exists.
if grep -q 'title: phosphor-dev-fixture$' <<< "$clients"; then
    echo 'fixture window: OK'
else
    echo 'fixture window: FAIL'
    failed=1
fi
exit "$failed"
