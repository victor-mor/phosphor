#!/usr/bin/env bash
set -uo pipefail

pkill -TERM -x start-hyprland 2>/dev/null || true
for ((i=0; i<5; i++)); do
    if ! pgrep -x Hyprland >/dev/null && ! pgrep -x start-hyprland >/dev/null; then
        break
    fi
    sleep 1
done
pkill -KILL -x Hyprland 2>/dev/null || true
pkill -TERM -x quickshell 2>/dev/null || true
for ((i=0; i<5; i++)); do
    pgrep -x quickshell >/dev/null || break
    sleep 1
done
pkill -KILL -x quickshell 2>/dev/null || true
for ((i=0; i<10; i++)); do
    if ! pgrep -x start-hyprland >/dev/null && ! pgrep -x Hyprland >/dev/null && ! pgrep -x quickshell >/dev/null; then
        break
    fi
    sleep 1
done

survivors=$(pgrep -a -x start-hyprland; pgrep -a -x Hyprland; pgrep -a -x quickshell)
if [[ -n $survivors ]]; then
    printf 'Session processes still running; keeping session folder:\n%s\n' "$survivors" >&2
    exit 1
fi
rm -rf /tmp/phosphor-dev/xdg
echo 'Nested session stopped'
