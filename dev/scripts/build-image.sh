#!/usr/bin/env bash
set -eu
cd "$(dirname "$0")/../.."
env -u NOTIFY_SOCKET podman build -f dev/Containerfile -t localhost/phosphor-devcontainer .
