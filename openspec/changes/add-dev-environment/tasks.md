Labels:
- [agent]: the implementer does it inside the repo.
- [user, host]: the user runs it on the host. Agents do not run host commands with side effects.
- [manual]: a person looks or listens; record what was observed.
Each check gives the expected result. Write the observed result next to it.

## 1. Image recipe

- [x] 1.1 [agent] Create `dev/Containerfile` pin lines for the ten sources:
  name, version, URL and commit for each. The build clones by the version tag
  and compares the resolved commit with this commit.
- [x] 1.2 [agent] Complete `dev/Containerfile`: Ubuntu 26.04 base by tag, packages, OpenCode install,
  clone each source by its version tag, resolve the tag to a commit, compare it with the pinned commit,
  stop on mismatch and name the source, build, install.
- [x] 1.3 [agent] Create `dev/scripts/build-image.sh` (Podman build, `NOTIFY_SOCKET` unset).
- [x] 1.4 [agent] Check: `bash -n dev/scripts/build-image.sh`.
  Expected: no output, exit 0.
- [x] 1.5 [user, host] Run the build command.
  Expected: image tagged. Observed: `bash dev/scripts/build-image.sh` built image 5ddc835367d0d5006040a9ecf9e97c54c60d1980f1dfcb3c3598b897bd923031, tag localhost/phosphor-devcontainer:latest (user report).
- [x] 1.6 [user, host] Mismatch test: in a copy of `dev/Containerfile`, change one pinned commit
  to a different commit, then build from that copy.
  Expected: build stops and names the source; no image tagged. Observed: "Source mismatch: quickshell (expected 9b0f339b19057f4731bf3b48293307d7ef241671, got 4f508be500dea6e5732cc3d50382a0048b17e7b1)". No new tag; latest unchanged. Dangling image 9d32ac9d7525 left from the failed build (user to remove). Rebuilt image: user reports the build stopped; exact message pending.
- [x] 1.7 [user, host] In the image, print the versions of Hyprland and Quickshell.
  Expected: 0.57.2 and 0.3.2. Observed: Hyprland 0.57.2, commit 11cbc6c577b84ffb1edf4df3fc5b6128c3ae6947, tag v0.57.2; hyprgraphics 0.6.0, hyprutils 0.14.3, aquamarine 0.16.0 match. Quickshell 0.3.2, revision 4f508be500dea6e5732cc3d50382a0048b17e7b1. Note: Hyprland reported "dirty" build tree; not explained. Rebuilt image, container 1e984f73a068: `hyprland --version` and `quickshell --version` reported the same versions, commit, tag, dependencies and revision as the previous image (user report).
- [x] 1.8 [user, host] In the image, run OpenCode and print its version.
  Expected: OpenCode runs and prints a version. Observed: opencode v2.4.1 prints its version. Rebuilt image, container 1e984f73a068: `opencode --version` reported v2.4.2 (user report). OpenCode is installed without a version pin (R11), so the version changed between builds.

## 2. Container start and nested Hyprland

- [x] 2.1 [agent] Create `dev/devcontainer.json` (image tag, `/parent-run` mounts, environment,
  host `WAYLAND_DISPLAY`, `/dev/dri/renderD128`). No keys in `containerEnv`.
  Note: the key source changed to the host keyring (decision 2); see 2.4.
  Observed: keys removed from `containerEnv` in `dev/devcontainer.json`; keys do not reach the container at creation (user report).
- [x] 2.2 [agent] Create `dev/hyprland/hyprland.lua` (fixture window rule, no env checks).
- [x] 2.3 [agent] Create `dev/scripts/start-session.sh`: refuse if Hyprland or its launcher is alive;
  create `/tmp/phosphor-dev/xdg` and `/tmp/phosphor-dev/logs`; start Hyprland; wait up to 30 s.
- [x] 2.4 [agent] Create `dev/scripts/start-dev.sh` (host): read the keys from the host keyring with
  `secret-tool lookup service openrouter` (`OPENROUTER_API_KEY`) and
  `secret-tool lookup service github-mcp` (`GITHUB_PERSONAL_ACCESS_TOKEN`)
  into shell variables (no `export`); warn and continue if a key is missing;
  never write or print keys.
  Steps: `devcontainer up --config dev/devcontainer.json` (no keys), run `start-session.sh`,
  run `start-fixture.sh`, then open the final shell with `devcontainer exec --remote-env` for each key found.
  Observed: after removing the old container, `start-dev.sh` printed no key values; with a stopped session, it exited 0 and printed "Nested session started" and "Fixture started". Both keys were non-empty in the final shell and empty in a later shell (user report). An earlier run failed due to wrong option order in the devcontainer command; this was fixed and the final version was tested.
- [x] 2.5 [agent] Check: `bash -n` on both scripts. Expected: exit 0.
- [x] 2.6 [user, host][manual] Run `start-dev.sh`.
  Expected: container runs; a nested Hyprland window appears; host bar and windows unchanged.
  Observed: `start-dev.sh` exit code 0; output "Nested session started" and "Fixture started"; in the container `pgrep` shows Hyprland (PIDs 65 and 69, the second likely the watchdog child, not verified) and quickshell (PID 135); the nested window appears and the host desktop is unchanged. The `OPENROUTER_API_KEY` and `GITHUB_PERSONAL_ACCESS_TOKEN` warnings still appeared (user report).
  Note: this run used the earlier key source; the key flow changed since (decision 2, see 6.4).
- [x] 2.7 [user, host] Run `start-session.sh` a second time while the session runs.
  Expected: error "already running"; `/tmp/phosphor-dev/xdg` still exists; one Hyprland only.
  Observed: `bash dev/scripts/start-session.sh` printed "Session already running"; `ls /tmp/phosphor-dev/xdg` before and after showed dconf, hypr, quickshell, wayland-1 and wayland-1.lock (folder kept). `pgrep -a Hyprland` showed PIDs 65 and 69 with the same command line; `ps -o pid,ppid,cmd -C Hyprland` showed PID 69 has PPID 65, a watchdog child of the same instance, not a second instance (user report).
- [x] 2.8 [agent] Add `--shell` mode to `dev/scripts/start-dev.sh`: keys and a shell only;
  error if the container is not running.
- [x] 2.9 [user, host][manual] Run `start-dev.sh --shell` with the container running.
  Expected: shell opens with keys (ok, ok), no value printed. Observed: with the container running, `bash dev/scripts/start-dev.sh --shell` opened the shell; both key checks gave ok (user report). No key value shown.
- [x] 2.10 [user, host][manual] Run `start-dev.sh --shell` with the container stopped.
  Expected: error, non-zero exit, nothing started. Observed: with the container stopped, `bash dev/scripts/start-dev.sh --shell` printed "Container not running. Run start-dev.sh first." and exited with code 1 (user report).

## 3. Fixture

- [x] 3.1 [agent] Create `dev/fixture/shell.qml` (title `phosphor-dev-fixture`, network and sound lines).
- [x] 3.2 [agent] Create `dev/scripts/start-fixture.sh`: error if no nested Hyprland;
  start Quickshell on the nested display; log to `/tmp/phosphor-dev/logs/quickshell.log`.
- [x] 3.3 [user, host][manual] Run `start-fixture.sh` in the container,
  or check after `start-dev.sh` (it starts the fixture).
  Expected: fixture window inside the nested Hyprland, with host network devices and default sink.
  Observed: fixture window visible in the nested session, with the network and sound lines (user report).
  With the session running, the user ran `pkill -KILL -x quickshell` in the container; the fixture disappeared. Then `bash /workspace/dev/scripts/start-fixture.sh` reported "Fixture started" and the fixture window reappeared (user report).
- [x] 3.4 [user, host] Run `start-fixture.sh` with no session.
  Expected: error "session not running". Observed: after `stop-session.sh` reported "Nested session stopped", the user ran `bash dev/scripts/start-fixture.sh` in the container; output: "Session not running" (user report; matches expected). With the session stopped, `bash /workspace/dev/scripts/start-fixture.sh` also printed "Session not running" (user report).

## 4. Check

- [x] 4.1 [agent] Create `dev/scripts/check-session.sh`: one line per check
  (wpctl, pactl, nmcli, fixture window); non-zero exit on any failure.
- [x] 4.2 [user, host] Run it with the fixture open.
  Expected: all lines OK, exit 0. Observed: with the fixture open, `bash /workspace/dev/scripts/check-session.sh; echo $?` printed `wpctl: OK`, `pactl: OK`, `nmcli: OK`, `fixture window: OK`, and exit code 0 (user report). The shell prompt showed `root@f521161ee505:/source`; the script was run at `/workspace/dev/scripts/check-session.sh`.
- [x] 4.3 [user, host] Run it with the fixture closed.
  Expected: fixture line fails, exit non-zero. Observed: with the fixture closed, `bash /workspace/dev/scripts/check-session.sh; echo $?` printed `wpctl: OK`, `pactl: OK`, `nmcli: OK`, `fixture window: FAIL`, and exit code 1 (user report; matches expected).
- [x] 4.4 [user, host] Run it with `PULSE_SERVER` pointing to a missing socket.
  Expected: audio line fails, exit non-zero. Observed: `PULSE_SERVER=unix:/tmp/no-existe bash /workspace/dev/scripts/check-session.sh; echo $?` printed `wpctl: OK`, `pactl: FAIL`, `nmcli: OK`, `fixture window: FAIL`, and exit code 1 (user report; matches expected). The fixture was closed from 4.3, so its failure is expected and does not affect this check.
- [x] 4.5 [user, host] In the container, list processes.
  Expected: no NetworkManager, PipeWire or D-Bus daemon. Observed: `pgrep -a NetworkManager; pgrep -a pipewire; pgrep -a dbus-daemon; echo done` printed only `done` (user report; matches expected).
- [x] 4.6 [user, host][manual] Play one test sound from the container and report whether it was heard.
  Expected: sound heard on the host. Observed: sound heard on the host (user report; matches expected). The exact sound command used was not recorded; the user confirmed it worked.

## 5. Stop

- [x] 5.1 [agent] Create `dev/scripts/stop-session.sh`: TERM launcher, wait, KILL Hyprland if alive,
  TERM then KILL Quickshell if alive, list survivors and exit non-zero; remove the session folder
  only when none remain; keep logs.
- [x] 5.2 [user, host][manual] Run it with the session and fixture running. Watch the host bar.
  Expected: exit 0; no `start-hyprland`, `Hyprland` or `quickshell` process (`pgrep`);
  `/tmp/phosphor-dev/xdg` gone; logs still in `/tmp/phosphor-dev/logs`;
  nested window closed; host bar still visible. Observed: `bash dev/scripts/stop-session.sh` printed "Nested session stopped" and exited 0 (`echo $?`); `pgrep -a Hyprland` and `pgrep -a quickshell` had no output; `ls -d /tmp/phosphor-dev/xdg` reported "No such file or directory"; `ls /tmp/phosphor-dev/logs` showed `hyprland.log` and `quickshell.log`; the nested window disappeared and everything on the host stayed visible (user report). The user also tested the absolute form `bash /workspace/dev/scripts/stop-session.sh`. The `start-hyprland` process check was missing before; the user then ran `bash dev/scripts/stop-session.sh` (output "Nested session stopped") and `pgrep -a start-hyprland; echo $?` printed 1 (no process).
- [x] 5.3 [user, host] Start again after the stop.
  Expected: session starts normally. Observed: after stop-session.sh (which printed 'Nested session stopped' and was followed by `pgrep -a start-hyprland; echo $?` returning 1), the user ran start-dev.sh. Current session: `pgrep -a start-hyprland` shows PID 3975; `pgrep -a Hyprland` shows PIDs 3981 and 3986. Start-dev exit code not reported. PPID of 3986 not checked. (user report)

## 6. Secrets

- [x] 6.1 [agent] Search the repo for key values, including every file in `dev/`.
  Expected: no key value found anywhere, including `dev/`.
  Keyring lookup names appear only in `dev/scripts/start-dev.sh`.
  Observed: no key values found in repo; lookup commands only (allowed).
- [x] 6.2 [user, host] Start with both keys found in the keyring; run `opencode` in the shell
  opened by `start-dev.sh`.
  Expected: keys available in the shell opened by `start-dev.sh`; OpenCode starts and sees its keys.
  Observed: in the final shell opened by `start-dev.sh`, OpenCode starts and can use the OpenRouter API key and the GitHub token for the GitHub MCP server (user report; matches expected). No key value was shown. The exact commands used were not recorded.
- [x] 6.3 [user, host] Start with one key missing in the keyring.
  Expected: warning; session still starts. Observed: with the GitHub token missing from the keyring, `start-dev.sh` printed "Warning: GITHUB_PERSONAL_ACCESS_TOKEN is not set" and the session started (user report; matches expected).
- [x] 6.4 [user, host][manual] Run `start-dev.sh` with keys in keyring.
  Expected: no key value printed anywhere in the output; `echo $OPENROUTER_API_KEY` in the final shell
  is not empty without printing it (use `[ -n "$OPENROUTER_API_KEY" ] && echo ok`). Observed: no key value in `start-dev.sh` output; non-empty checks returned `ok` for both keys in the final shell and `vacia` for both in a later shell (user report).

## 7. Documentation

- [x] 7.1 [agent] Rewrite `docs/development.md`: host prerequisites, build, start, fixture,
  check, stop, log locations, known limitations, verified host NixOS 26.05.
  Mark manual checks as manual. List only commands verified in sections 1–6.
- [x] 7.2 [agent] Known limitations to record: `hyprctl dispatch exit` fails with Lua config;
  Waybar disappeared once during a stop (cause unknown); real audio playback and Wi-Fi control
  not verified (unless 4.6 passes); Ubuntu packages not pinned; GPU device fixed; other hosts untested;
  keys exist only in shells opened by `start-dev.sh` (full start or `--shell`), not in other shells;
  key values are `devcontainer exec` arguments, maybe visible in the host process list or its logs (not tested).
- [x] 7.3 [agent] Create `dev/README.md` (pointer) and update the `README.md` status line.
- [x] 7.4 [agent] Check: every command in `docs/development.md` matches an observed result above.
  Expected: no command without a recorded result.
  Observed: mapped to 1.5, 2.4, 2.9, 2.10, 3.4, 4.2, 4.3 and 5.2. Task 1.5 records the image tag but not the exact build command; 3.4 and 5.2 record relative container paths. The guide uses the user-selected host and container path forms.

## 8. Final check

- [x] 8.1 [agent] Run `openspec validate add-dev-environment`. Expected: valid.
- [x] 8.2 [agent] Check that each commit of this change contains only its approved files: `git show --stat` for the commits of feature/dev-environment created for this change. Expected: each listed commit touches only its approved files; no commit includes MEMORY.md or opencode.json. Observed: Each commit matches its approved list: 157a257 (agent files + AGENTS.md), 481a12b (change files), c4b3e50 (dev/, docs/development.md, README.md, change folder), e58495d (sdd-coordinator.md, sdd-planner.md). No commit includes MEMORY.md or opencode.json.
