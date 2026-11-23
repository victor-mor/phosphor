## Context

The repo has no launch environment yet.
The constitution says `dev/` holds the controlled launch and debug environment,
separate from runtime UI code.
The host is NixOS 26.05. Hyprland 0.57.2 and Quickshell 0.3.2 are not packaged there,
so a container builds them on Ubuntu 26.04.

## Goals / Non-Goals

**Goals:**
- Repeatable image with the ten sources at fixed commits.
- Start, fixture, check and stop commands with clear success and failure.
- Safe start and stop: never wipe a live session, never leave processes behind.

**Non-Goals:**
- Product widgets, real service integration, persistence, IPC, plugins, CI.
- Hosts other than NixOS 26.05.
- Services or simulated devices inside the container.

## Decisions

### D1. All files live in `dev/`
Layout:
- `dev/Containerfile`: image recipe. It holds one pin line per source:
  name, version, URL, commit. Single source of truth.
- `dev/devcontainer.json`: container config (mounts, environment, image tag, editor extension).
- `dev/hyprland/hyprland.lua`: nested Hyprland config.
- `dev/fixture/shell.qml`: minimal Quickshell test window.
- `dev/scripts/`: `build-image.sh`, `start-dev.sh` (host);
  `start-fixture.sh`, `check-session.sh`, `stop-session.sh`, `start-session.sh` (container).
- `dev/README.md`: two lines that point to `docs/development.md`.
Reason: the constitution reserves `dev/` for this. The README already plans it.

### D2. The build checks every commit
There are ten sources: Hyprland, Quickshell, aquamarine, hyprutils, hyprgraphics,
hyprland-protocols, hyprwire, cpptrace, wayland and wayland-protocols.
Each has one version and one commit, written in `dev/Containerfile`.
The build clones each source at its commit (decision 1).
After checkout it compares `git rev-parse HEAD` with the commit.
On mismatch it stops, names that source, and tags no image.
Hyprland submodules come from the pinned Hyprland commit.
The base image is Ubuntu 26.04, by tag.
Reason: today the pins are only written down; nothing checks them.

### D3. The repo root is the workspace
The devcontainer CLI uses `--config dev/devcontainer.json` with the repo root as workspace.
The repo is mounted at `/workspace`. Scripts use `/workspace/dev/...` paths.
Reason: developers edit the real repo inside the container.
Not verified: `--config` with Podman on this host.

### D4. Host sockets under `/parent-run`
Mounts: host Wayland socket (from `WAYLAND_DISPLAY`), system bus, session bus,
`pipewire-0`, `pulse/native`, all under `/parent-run/`.
Environment: `DBUS_SESSION_BUS_ADDRESS`, `DBUS_SYSTEM_BUS_ADDRESS`, `PULSE_SERVER`,
`PIPEWIRE_RUNTIME_DIR` point there.
Reason: never mount the host `/run/user/1000` over the container's own;
user IDs map differently inside a rootless container.
The image has only client tools: `nmcli`, `wpctl`, `pactl`. No daemons.
`tini` is the first process. No systemd.

### D5. Users
Hyprland and Quickshell run as root inside the container.
Hyprland needs the flag `--i-am-really-stupid` to accept root.
In a rootless container, root maps to the host user, so it has no extra host rights.
PipeWire runs on the host as the user.

### D6. Session folder and logs
- Session folder (`XDG_RUNTIME_DIR` for Hyprland): `/tmp/phosphor-dev/xdg`.
- Logs: `/tmp/phosphor-dev/logs/` (`hyprland.log`, `quickshell.log`).
  Stop keeps logs; the next start replaces them (decision 3).
- Hyprland's own internal log is inside the session folder and is removed at stop.

### D7. Start is safe
`start-session.sh` first checks for a live `Hyprland` or `start-hyprland` process.
If one is alive, it stops with an error and deletes nothing.
Then it creates the folder, starts `start-hyprland`, and waits up to 30 s for an instance.
`start-dev.sh` (host) runs `devcontainer up`, then `start-session.sh`, then opens a shell.

### D8. Stop uses signals
`hyprctl dispatch exit` fails with the Lua config, so stop uses signals.
Order: TERM to the launcher (it restarts Hyprland otherwise), wait,
KILL Hyprland if still alive, then TERM Quickshell, wait, KILL if still alive.
It lists any survivor and exits with an error; it keeps the folder in that case.

### D9. Check is strict
`check-session.sh` runs `wpctl status`, `pactl info`, `nmcli general`, and looks for
the fixture title in `hyprctl clients`. Any failure gives a non-zero exit.
It cannot prove that sound is heard. That is a manual check.

### D10. Keys
`start-dev.sh` passes `OPENROUTER_API_KEY` and `GITHUB_PERSONAL_ACCESS_TOKEN`
from the host environment (decision 2). It warns if one is empty and continues.
The keys are never written to files or the image.

### D11. Build environment
`build-image.sh` runs `podman build` with `NOTIFY_SOCKET` unset.
Reason: if set, the build leaves a root-owned `/run/user/<uid>/systemd/notify` in the image.

### D12. The OpenCode editor extension
`dev/devcontainer.json` lists `sst-dev.opencode` under `customizations.vscode.extensions`.
It comes from Open VSX, the extension store VSCodium uses (decision 7).
The extension is not part of the image. The editor installs it when it opens the container.
Assumption, not verified: the extension calls the `opencode` command inside the container,
which the image already installs.

## Risks / Trade-offs

- Ubuntu packages are not pinned → a later build may get newer packages.
  Known limitation (decision 4).
- GPU device fixed to `/dev/dri/renderD128` → other machines may need a different one.
  Known limitation (decision 5).
- Waybar on the host disappeared once during a stop. Cause unknown.
  Documented as a known limitation. The stop check watches the host bar.
- Real audio playback is checked once by hand (decision 6). If not heard, known limitation.
- Wi-Fi control from the container is not verified.
- Hosts other than NixOS 26.05 are not tested.
- Side effects: Podman image storage (several GB), network downloads during build,
  a running container (`sleep infinity` under `tini`) until the user stops it.
- Old experiment containers and images may still exist. This change does not touch them.
