#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
    "") [[ $# -eq 0 ]] || { echo "Usage: $0 [--shell]" >&2; exit 2; } ;;
    --shell) [[ $# -eq 1 ]] || { echo "Usage: $0 [--shell]" >&2; exit 2; } ;;
    *) echo "Usage: $0 [--shell]" >&2; exit 2 ;;
esac

OPENROUTER_API_KEY=$(secret-tool lookup service openrouter || true)
GITHUB_PERSONAL_ACCESS_TOKEN=$(secret-tool lookup service github-mcp || true)

for key in OPENROUTER_API_KEY GITHUB_PERSONAL_ACCESS_TOKEN; do
    if [[ -z ${!key:-} ]]; then
        echo "Warning: $key is not set" >&2
    fi
done

workspace=$(cd "$(dirname "$0")/../.." && pwd)
opts=(--workspace-folder "$workspace" --config "$workspace/dev/devcontainer.json" --docker-path /run/current-system/sw/bin/podman)

if [[ ${1:-} == --shell ]]; then
    if [[ -z $(/run/current-system/sw/bin/podman ps --filter "label=devcontainer.local_folder=$workspace" --format '{{.Names}}') ]]; then
        echo "Container not running. Run start-dev.sh first." >&2
        exit 1
    fi
    devcontainer exec "${opts[@]}" \
        --remote-env "OPENROUTER_API_KEY=$OPENROUTER_API_KEY" \
        --remote-env "GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_PERSONAL_ACCESS_TOKEN" \
        bash
    exit
fi

devcontainer up "${opts[@]}"
devcontainer exec "${opts[@]}" bash /workspace/dev/scripts/start-session.sh
devcontainer exec "${opts[@]}" bash /workspace/dev/scripts/start-fixture.sh
devcontainer exec "${opts[@]}" \
    --remote-env "OPENROUTER_API_KEY=$OPENROUTER_API_KEY" \
    --remote-env "GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_PERSONAL_ACCESS_TOKEN" \
    bash
