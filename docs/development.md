# Development environment

## Host prerequisites

The verified host is NixOS 26.05. Use rootless Podman, devcontainer CLI 0.87.0,
secret-tool with a Linux keyring, and a Wayland desktop. The keyring lookup names
are `service openrouter` and `service github-mcp`. The build needs network access
and several GB of image storage. Run host commands from the repository root.

## Build

[user, host] Run `bash dev/scripts/build-image.sh`. The image is tagged
`localhost/phosphor-devcontainer:latest`. A source mismatch stops the build and
names the source.

## Start and fixture

[user, host] Run `bash dev/scripts/start-dev.sh`. It starts the container, nested
session and fixture, then opens a final shell. Keys are available only in that
shell or another shell opened by this script, not in other shells.

[user, host] With the container running, run `bash dev/scripts/start-dev.sh --shell`
to open another shell with the keys without starting a session. If the container
is stopped, it reports an error and exits with code 1.

[manual] The fixture appears in the nested session with network and sound lines.
[user, container] Run `bash /workspace/dev/scripts/start-fixture.sh` to start the
fixture separately. With no session running, it reports `Session not running`.

## Check

[user, container] Run `bash /workspace/dev/scripts/check-session.sh`. With the
fixture open, the user observed OK for wpctl, pactl, nmcli and the fixture
window, with exit 0. With the fixture closed, the fixture check failed and the
command exited 1. The audio checks show that the servers answer, not that sound
is heard.

[manual] The user played a test sound in the container and heard it on the host.

## Stop and logs

[user, container] Run `bash /workspace/dev/scripts/stop-session.sh`.
The user verified exit 0, no session processes, removal of the session folder,
and retained logs in `/tmp/phosphor-dev/logs`.

The logs inside the container are `/tmp/phosphor-dev/logs/hyprland.log` and
`/tmp/phosphor-dev/logs/quickshell.log`.

## Limitations

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
