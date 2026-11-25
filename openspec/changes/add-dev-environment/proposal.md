## Why

Phosphor has no way to run or see its UI yet.
Developers need a repeatable place to build and test it.
That place must not touch the desktop they are working on.
Related issue: #1.

## What Changes

- Add a development container image (Ubuntu 26.04 base, by tag).
- The image builds Hyprland, Quickshell and their libraries at fixed commits.
  The versions and commits are written in the image recipe.
- The build stops if a source does not match its fixed commit.
- The image installs OpenCode.
- Add host scripts to build the image and start the container.
  The start script reads the API keys from the host keyring.
- The start script has a `--shell` mode: it opens a new shell with the keys in the running container.
  It starts nothing.
- Starting the container also starts a nested Hyprland in its own window.
  "Nested" means Hyprland runs as a normal window inside the current desktop.
- Add container scripts to start a minimal Quickshell test window (the "fixture"),
  check the session, and stop it. The normal start also starts the fixture.
- The container uses the host's services (NetworkManager, PipeWire, PulseAudio,
  D-Bus, Wayland) through mounted sockets. It runs no service daemons of its own.
- Start refuses to wipe the session folder while Hyprland is still running.
- Check fails when audio, network or the fixture window is not available.
- Stop confirms that Hyprland, its launcher and Quickshell are gone before cleanup.
- Write `docs/development.md` with prerequisites, commands, logs and limitations.
- All files live in `dev/`.

## Capabilities

### New Capabilities

- `dev-environment`: build, start, check and stop the nested development session.

### Modified Capabilities

None.

## Impact

- New folder `dev/` (image recipe, devcontainer config, scripts, Hyprland config, fixture).
- Rewritten `docs/development.md`. Small status update in `README.md`.
- Host needs: Podman (rootless), devcontainer CLI, a Wayland desktop, network for the build,
  `secret-tool` (Linux keyring client) for the API keys.
- Building uses several GB of Podman storage and downloads sources and packages.
- Verified host: NixOS 26.05 only. Other hosts are not supported yet.
- Out of scope: product widgets, system service integration, persistence, IPC, plugins,
  full test suite or CI, other hosts, a system image with its own services or simulated devices.
- Known limitations (not tested yet):
  - Key values are command-line arguments of `devcontainer exec`.
    They may be visible in the host process list for a moment.
  - It is unknown whether `devcontainer exec` logs them.
  - VS Code / VSCodium attach is not planned for now.

## Decisions

1. Sources. Accepted by user.
   - The image build clones each repository by its version tag, gets the commit of that tag,
     and compares it with the commit pinned in `dev/Containerfile`.
   - The versions and commits are written in `dev/Containerfile` itself.
2. API keys. Accepted by user; changed by user.
   - The host start script `dev/scripts/start-dev.sh` reads both keys from the host keyring
     with `secret-tool lookup`:
     - `OPENROUTER_API_KEY`: `secret-tool lookup service openrouter`
     - `GITHUB_PERSONAL_ACCESS_TOKEN`: `secret-tool lookup service github-mcp`
   - The lookup names live in that script. They are not secrets and may be in the repo.
   - If a key is missing, it warns and continues; the session does not need it.
   - Keys are never written to files or the image.
   - Changed by user: keys are not in the container's environment at creation
     (not in `dev/devcontainer.json`, not passed to `devcontainer up`).
     The script passes them only to the final shell it opens, with `devcontainer exec --remote-env`.
   - The script never prints key values.
   - The keys also reach a new shell opened with `start-dev.sh --shell`.
     Still, only shells opened by the script get them.
   - Any other shell opened later in the container has no keys. Start OpenCode from a script's shell.
3. Logs. Accepted by user.
   - A log folder inside the container, separate from the session folder.
   - Stop keeps it. The next start replaces it.
4. Ubuntu packages. Accepted by user.
   - They are not pinned. This is documented as a known limitation.
5. GPU device and Wayland socket. Accepted by user.
   - Use the host `WAYLAND_DISPLAY` value.
   - The GPU device stays `/dev/dri/renderD128`. This is documented as a known limitation.
6. Manual audio check. Accepted by user.
   - The user plays one test sound from the container and reports whether it was heard.
   - If it is not heard, it stays as a known limitation.
