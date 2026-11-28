# Development environment

See [OpenSpec](../openspec/) and the [verification practice](../AGENTS.md#8-evidence-and-memory).

## What you need

The verified host is NixOS 26.05. You need rootless Podman, devcontainer CLI
0.87.0, secret-tool with a Linux keyring, and a Wayland desktop. The keyring
lookup names are `service openrouter` and `service github-mcp`. The build needs
network access and several GB of image storage. Run host commands from the
repository root.

## Build the image

[user, host] Run `bash dev/scripts/build-image.sh` [tested: 1.5]. The image is
tagged `localhost/phosphor-devcontainer:latest`. A source mismatch stops the
build and names the source.

## Start the dev environment

[user, host] [manual] Run `bash dev/scripts/start-dev.sh` [tested: 2.4]. It starts the
container, nested session and fixture. Then it opens a final shell. Keys are
available only in that shell or another shell opened by this script, not in
other shells.

[manual] Check that the nested window appears and the host bar and windows remain unchanged.

[user, container] [manual] If the start fails, run `bash /workspace/dev/scripts/stop-session.sh`
[tested: 5.2] inside the container before trying again. Failed-start cleanup has not
been tested.

[user, host] [manual] With the container running, run `bash dev/scripts/start-dev.sh --shell`
[tested: 2.9, 2.10]. It opens another shell with the keys without starting a
session. If the container is stopped, it reports an error and exits with code 1.

[manual] The fixture appears in the nested session with network and sound lines.
[user, container] [manual] Run `bash /workspace/dev/scripts/start-fixture.sh` to start the
fixture separately [tested: 3.3, 3.4]. It starts the fixture when the session is
running. With no session, it reports `Session not running`.

## Check the session

[user, container] [manual] Run `bash /workspace/dev/scripts/check-session.sh` [tested:
4.2, 4.3]. With the fixture open, the user observed OK for wpctl, pactl, nmcli
and the fixture window, with exit 0. With the fixture closed, the fixture check
failed and the command exited 1. The audio checks show that the servers answer,
not that sound is heard.

[manual] The user played a test sound in the container and heard it on the host.

## Stop the session

[user, container] [manual] Run `bash /workspace/dev/scripts/stop-session.sh` [tested:
5.2]. The user verified exit 0, no session processes, removal of the session
folder, and retained logs in `/tmp/phosphor-dev/logs`.

This stops only the nested session and closes its window, not the container.
[manual] Check that the nested window closes and the host bar remains visible.
[user, host] [not tested yet, host] Use the container name from `podman ps`, then run
`podman stop <container>` followed by `podman rm <container>`.

## Logs

The logs inside the container are `/tmp/phosphor-dev/logs/hyprland.log` and
`/tmp/phosphor-dev/logs/quickshell.log`.
[manual] Investigate WARNING, ERROR and CRITICAL logs.

## Known limitations

- The image keeps `network-manager` and `wireplumber` on purpose for `check-session.sh`: `nmcli` comes from `network-manager`, `wpctl` from `wireplumber`, and `pactl` from `pulseaudio-utils`. Their daemons do not run in the container; the user checked this with `pgrep` (task 4.5).
- Hyprland's exit dispatch fails with the Lua config.
- Waybar disappeared once on the host during a stop; the cause is unknown.
- Wi-Fi control from the container is not verified.
- Ubuntu packages are not pinned. The GPU device is fixed to `/dev/dri/renderD128`.
  Other hosts are untested.
- The Hyprland build tree was reported as "dirty"; the reason is unknown.
- Keys are available only in shells opened by the start script, either the final
  shell or a shell opened with its shell mode, not in other shells.
- Key values are arguments to the container exec operation. They may be visible
  in the host process list or its logs; neither was tested.
