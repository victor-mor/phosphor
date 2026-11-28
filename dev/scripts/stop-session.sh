#!/usr/bin/env bash
# Stop the nested session and fixture inside the container.
# Inputs: none. Output: stop status; exits 1 if unsafe or processes survive.
set -uo pipefail

# Guard against killing matching processes on the host.
if [[ ! -e /run/.containerenv && ! -e /.dockerenv ]]; then
    echo 'stop-session.sh runs inside the container only' >&2
    exit 1
fi

# Allow the session to stop cleanly before forcing remaining processes.
pkill -TERM -x start-hyprland 2>/dev/null || true
for ((i=0; i<5; i++)); do
    if ! pgrep -x Hyprland >/dev/null && ! pgrep -x start-hyprland >/dev/null; then
        break
    fi
    sleep 1
done
pkill -KILL -x Hyprland 2>/dev/null || true
# Give the fixture the same chance to exit cleanly.
pkill -TERM -x quickshell 2>/dev/null || true
for ((i=0; i<5; i++)); do
    pgrep -x quickshell >/dev/null || break
    sleep 1
done
pkill -KILL -x quickshell 2>/dev/null || true
# Wait for forced exits before deciding whether cleanup is safe.
for ((i=0; i<10; i++)); do
    if ! pgrep -x start-hyprland >/dev/null && ! pgrep -x Hyprland >/dev/null && ! pgrep -x quickshell >/dev/null; then
        break
    fi
    sleep 1
done

# Keep the runtime directory if any session process still needs it.
survivors=$(pgrep -a -x start-hyprland; pgrep -a -x Hyprland; pgrep -a -x quickshell)
if [[ -n $survivors ]]; then
    printf 'Session processes still running; keeping session folder:\n%s\n' "$survivors" >&2
    exit 1
fi
rm -rf /tmp/phosphor-dev/xdg
echo 'Nested session stopped'
