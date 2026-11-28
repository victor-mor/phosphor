#!/usr/bin/env bash
# Start a nested Hyprland session inside the container.
# Input: WAYLAND_DISPLAY. Output: session log; exits 1 on failure.
set -euo pipefail

# Avoid conflicting nested sessions.
if pgrep -x Hyprland >/dev/null || pgrep -x start-hyprland >/dev/null; then
    echo 'Session already running' >&2
    exit 1
fi

# Give the nested session a fresh private runtime directory.
rm -rf /tmp/phosphor-dev/xdg
mkdir -p /tmp/phosphor-dev/logs
mkdir -m 0700 /tmp/phosphor-dev/xdg
export XDG_RUNTIME_DIR=/tmp/phosphor-dev/xdg

# Detach from the launcher and target the parent display, not its instance.
env -u HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY="/parent-run/${WAYLAND_DISPLAY}" \
    setsid nohup start-hyprland -- --i-am-really-stupid -c /workspace/dev/hyprland/hyprland.lua \
    < /dev/null > /tmp/phosphor-dev/logs/hyprland.log 2>&1 &

# Wait for an instance, then check it survives initial startup.
for ((i=0; i<30; i++)); do
    instances=$(env -u HYPRLAND_INSTANCE_SIGNATURE hyprctl -j instances 2>/dev/null || true)
    if [[ $instances == *'"instance"'* ]]; then
        sleep 5
        instances=$(env -u HYPRLAND_INSTANCE_SIGNATURE hyprctl -j instances 2>/dev/null || true)
        if [[ $instances == *'"instance"'* ]]; then
            echo 'Nested session started'
            exit 0
        fi
        echo 'Nested session stopped after start' >&2
        tail -20 /tmp/phosphor-dev/logs/hyprland.log >&2
        exit 1
    fi
    sleep 1
done
echo 'Nested session did not start' >&2
tail -20 /tmp/phosphor-dev/logs/hyprland.log >&2
exit 1
