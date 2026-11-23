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
- The container includes the OpenCode extension `sst-dev.opencode` for VS Code and VSCodium clients
  (from Open VSX).
- Add host scripts to build the image and start the container.
- Starting the container also starts a nested Hyprland in its own window.
  "Nested" means Hyprland runs as a normal window inside the current desktop.
- Add container scripts to start a minimal Quickshell test window (the "fixture"),
  check the session, and stop it.
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
- Host needs: Podman (rootless), devcontainer CLI, a Wayland desktop, network for the build.
- Building uses several GB of Podman storage and downloads sources and packages.
- Verified host: NixOS 26.05 only. Other hosts are not supported yet.
- Out of scope: product widgets, system service integration, persistence, IPC, plugins,
  full test suite or CI, other hosts, a system image with its own services or simulated devices.

## Decisions

1. Sources. Accepted by user.
   - The image build clones each repository at its fixed commit and checks it.
   - The versions and commits are written in `dev/Containerfile` itself.
2. API keys. Accepted by user.
   - The start script passes keys already set in the host environment.
   - If a key is missing, it warns and continues; the session does not need it.
   - Keys are never written to files or the image.
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
7. OpenCode editor extension. Accepted by user.
   - It is installed only inside the dev container.
   - It comes from Open VSX. ID: `sst-dev.opencode`.
