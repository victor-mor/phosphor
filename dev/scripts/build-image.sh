#!/usr/bin/env bash
# Build the development image on the host.
# Inputs: none. Output: a local image; exits nonzero on failure.
set -eu
# Use the repository root as the build context.
cd "$(dirname "$0")/../.."
# Keep host service notifications out of the image build.
env -u NOTIFY_SOCKET podman build -f dev/Containerfile -t localhost/phosphor-devcontainer .
