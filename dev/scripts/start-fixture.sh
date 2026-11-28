#!/usr/bin/env bash
# Start the Quickshell fixture inside the container.
# Inputs: none. Output: fixture log; exits 1 if startup fails.
set -euo pipefail

# Avoid starting a second fixture.
if pgrep -x quickshell >/dev/null; then
    echo 'Fixture already running' >&2
    exit 1
fi

# Discover the nested display instead of inheriting the parent session.
export XDG_RUNTIME_DIR=/tmp/phosphor-dev/xdg
instances=$(env -u HYPRLAND_INSTANCE_SIGNATURE hyprctl -j instances 2>/dev/null || true)
instance=$(grep -oP '"instance"\s*:\s*"\K[^"]+' <<< "$instances" | head -1 || true)
display=$(grep -oP '"wl_socket"\s*:\s*"\K[^"]+' <<< "$instances" | head -1 || true)
if [[ -z $instance || -z $display ]] || ! pgrep -x Hyprland >/dev/null; then
    echo 'Session not running' >&2
    exit 1
fi

# Detach the fixture so it survives the launcher exiting.
export HYPRLAND_INSTANCE_SIGNATURE=$instance WAYLAND_DISPLAY=$display
setsid nohup quickshell -p /workspace/dev/fixture/shell.qml < /dev/null > /tmp/phosphor-dev/logs/quickshell.log 2>&1 &
# Catch a fixture that exits shortly after launch.
sleep 5
if pgrep -x quickshell >/dev/null; then
    echo 'Fixture started'
    exit 0
fi
echo 'Fixture stopped after start' >&2
tail -n 20 /tmp/phosphor-dev/logs/quickshell.log
exit 1
