Labels:
- [agent]: the implementer does it inside the repo.
- [user, host]: the user runs it on the host. Agents do not run host commands with side effects.
- [manual]: a person looks or listens; record what was observed.
Each check gives the expected result. Write the observed result next to it.

## 1. Image recipe

- [ ] 1.1 [agent] Create `dev/Containerfile` pin lines for the ten sources:
  name, version, URL and commit for each.
- [ ] 1.2 [agent] Complete `dev/Containerfile`: Ubuntu 26.04 base by tag, packages, OpenCode install,
  clone each source from its pin line, compare `git rev-parse HEAD` with the commit,
  stop on mismatch and name the source, build, install.
- [ ] 1.3 [agent] Create `dev/scripts/build-image.sh` (Podman build, `NOTIFY_SOCKET` unset).
- [ ] 1.4 [agent] Check: `bash -n dev/scripts/build-image.sh`.
  Expected: no output, exit 0.
- [ ] 1.5 [user, host] Run the build command.
  Expected: image tagged. Observed: ___
- [ ] 1.6 [user, host] Mismatch test: build once with one commit changed in a copy of `dev/Containerfile`.
  Expected: build stops and names the source; no image tagged. Observed: ___
- [ ] 1.7 [user, host] In the image, print the versions of Hyprland and Quickshell.
  Expected: 0.57.2 and 0.3.2. Observed: ___
- [ ] 1.8 [user, host] In the image, run OpenCode and print its version.
  Expected: OpenCode runs and prints a version. Observed: ___

## 2. Container start and nested Hyprland

- [ ] 2.1 [agent] Create `dev/devcontainer.json` (image tag, `/parent-run` mounts, environment,
  host `WAYLAND_DISPLAY`, `/dev/dri/renderD128`, keys from host environment).
- [ ] 2.1a [agent] Add `sst-dev.opencode` to `customizations.vscode.extensions` in `dev/devcontainer.json`.
- [ ] 2.2 [agent] Create `dev/hyprland/hyprland.lua` (fixture window rule, no env checks).
- [ ] 2.3 [agent] Create `dev/scripts/start-session.sh`: refuse if Hyprland or its launcher is alive;
  create `/tmp/phosphor-dev/xdg` and `/tmp/phosphor-dev/logs`; start Hyprland; wait up to 30 s.
- [ ] 2.4 [agent] Create `dev/scripts/start-dev.sh` (host): warn on missing keys,
  `devcontainer up --config dev/devcontainer.json`, run `start-session.sh`, open a shell.
- [ ] 2.5 [agent] Check: `bash -n` on both scripts. Expected: exit 0.
- [ ] 2.6 [user, host][manual] Run `start-dev.sh`.
  Expected: container runs; a nested Hyprland window appears; host bar and windows unchanged.
  Observed: ___
- [ ] 2.7 [user, host] Run `start-session.sh` a second time while the session runs.
  Expected: error "already running"; `/tmp/phosphor-dev/xdg` still exists; one Hyprland only.
  Observed: ___
- [ ] 2.8 [user, host][manual] Open the dev container from VSCodium.
  Expected: extension `sst-dev.opencode` installed and active, from Open VSX. Observed: ___

## 3. Fixture

- [ ] 3.1 [agent] Create `dev/fixture/shell.qml` (title `phosphor-dev-fixture`, network and sound lines).
- [ ] 3.2 [agent] Create `dev/scripts/start-fixture.sh`: error if no nested Hyprland;
  start Quickshell on the nested display; log to `/tmp/phosphor-dev/logs/quickshell.log`.
- [ ] 3.3 [user, host][manual] Run `start-fixture.sh` in the container.
  Expected: fixture window inside the nested Hyprland, with host network devices and default sink.
  Observed: ___
- [ ] 3.4 [user, host] Run `start-fixture.sh` with no session.
  Expected: error "session not running". Observed: ___

## 4. Check

- [ ] 4.1 [agent] Create `dev/scripts/check-session.sh`: one line per check
  (wpctl, pactl, nmcli, fixture window); non-zero exit on any failure.
- [ ] 4.2 [user, host] Run it with the fixture open.
  Expected: all lines OK, exit 0. Observed: ___
- [ ] 4.3 [user, host] Run it with the fixture closed.
  Expected: fixture line fails, exit non-zero. Observed: ___
- [ ] 4.4 [user, host] Run it with `PULSE_SERVER` pointing to a missing socket.
  Expected: audio line fails, exit non-zero. Observed: ___
- [ ] 4.5 [user, host] In the container, list processes.
  Expected: no NetworkManager, PipeWire or D-Bus daemon. Observed: ___
- [ ] 4.6 [user, host][manual] Play one test sound from the container and report whether it was heard.
  Expected: sound heard on the host. Observed: ___ (if not heard: keep as known limitation)

## 5. Stop

- [ ] 5.1 [agent] Create `dev/scripts/stop-session.sh`: TERM launcher, wait, KILL Hyprland if alive,
  TERM then KILL Quickshell if alive, list survivors and exit non-zero; remove the session folder
  only when none remain; keep logs.
- [ ] 5.2 [user, host][manual] Run it with the session and fixture running. Watch the host bar.
  Expected: exit 0; no `start-hyprland`, `Hyprland` or `quickshell` process (`pgrep`);
  `/tmp/phosphor-dev/xdg` gone; logs still in `/tmp/phosphor-dev/logs`;
  nested window closed; host bar still visible. Observed: ___
- [ ] 5.3 [user, host] Start again after the stop.
  Expected: session starts normally. Observed: ___

## 6. Secrets

- [ ] 6.1 [agent] Search the repo and `dev/` for key values or keyring names.
  Expected: none found.
- [ ] 6.2 [user, host] Start with keys set; run `opencode` in the container.
  Expected: OpenCode starts and sees its keys. Observed: ___
- [ ] 6.3 [user, host] Start with one key unset.
  Expected: warning; session still starts. Observed: ___

## 7. Documentation

- [ ] 7.1 [agent] Rewrite `docs/development.md`: host prerequisites, build, start, fixture,
  check, stop, log locations, known limitations, verified host NixOS 26.05.
  Mark manual checks as manual. List only commands verified in sections 1–6.
- [ ] 7.2 [agent] Known limitations to record: `hyprctl dispatch exit` fails with Lua config;
  Waybar disappeared once during a stop (cause unknown); real audio playback and Wi-Fi control
  not verified (unless 4.6 passes); Ubuntu packages not pinned; GPU device fixed; other hosts untested;
  extension `sst-dev.opencode` is third-party to this repo, not verified beyond install (no review of its code).
- [ ] 7.3 [agent] Create `dev/README.md` (pointer) and update the `README.md` status line.
- [ ] 7.4 [agent] Check: every command in `docs/development.md` matches an observed result above.
  Expected: no command without a recorded result.

## 8. Final check

- [ ] 8.1 [agent] Run `openspec validate add-dev-environment`. Expected: valid.
- [ ] 8.2 [agent] `git status`: only `dev/`, `docs/development.md`, `README.md` and this change changed.
  Expected: no unrelated files.
