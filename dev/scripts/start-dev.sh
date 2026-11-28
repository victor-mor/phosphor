#!/usr/bin/env bash
# Start the development environment or open a shell on the host.
# Input: optional --shell; keyring services openrouter and github-mcp.
# Output: an interactive container shell; invalid usage exits 2.
set -euo pipefail

# Reject ambiguous invocations before accessing the keyring.
case "${1:-}" in
    "") [[ $# -eq 0 ]] || { echo "Usage: $0 [--shell]" >&2; exit 2; } ;;
    --shell) [[ $# -eq 1 ]] || { echo "Usage: $0 [--shell]" >&2; exit 2; } ;;
    *) echo "Usage: $0 [--shell]" >&2; exit 2 ;;
esac

# Missing keys should not prevent development without those services.
OPENROUTER_API_KEY=$(secret-tool lookup service openrouter || true)
GITHUB_PERSONAL_ACCESS_TOKEN=$(secret-tool lookup service github-mcp || true)

# Preserve each key as one argument and pass it only to the shell.
remote=()
for key in OPENROUTER_API_KEY GITHUB_PERSONAL_ACCESS_TOKEN; do
    if [[ -z ${!key:-} ]]; then
        echo "Warning: $key is not set" >&2
    else
        remote+=(--remote-env "$key=${!key}")
    fi
done

# Resolve the workspace independently of the caller's directory.
workspace=$(cd "$(dirname "$0")/../.." && pwd)
opts=(--workspace-folder "$workspace" --config "$workspace/dev/devcontainer.json" --docker-path podman)

# Shell-only mode must not implicitly start a container.
if [[ ${1:-} == --shell ]]; then
    if [[ -z $(podman ps --filter "label=devcontainer.local_folder=$workspace" --format '{{.Names}}') ]]; then
        echo "Container not running. Run start-dev.sh first." >&2
        exit 1
    fi
    devcontainer exec "${opts[@]}" \
        ${remote[@]+"${remote[@]}"} \
        bash
    exit
fi

# Start the session and fixture before entering the interactive shell.
devcontainer up "${opts[@]}"
devcontainer exec "${opts[@]}" bash /workspace/dev/scripts/start-session.sh
devcontainer exec "${opts[@]}" bash /workspace/dev/scripts/start-fixture.sh
devcontainer exec "${opts[@]}" \
    ${remote[@]+"${remote[@]}"} \
    bash
