## ADDED Requirements

### Requirement: Hyprland source pin
The development image SHALL build Hyprland 0.57.2 from commit `11cbc6c577b84ffb1edf4df3fc5b6128c3ae6947`.

#### Scenario: Hyprland commit does not match
- **WHEN** the build resolves the Hyprland version tag to a commit that differs from the pinned commit
- **THEN** the build stops with an error that names Hyprland
- **AND** no image is tagged

### Requirement: Quickshell source pin
The development image SHALL build Quickshell 0.3.2 from commit `4f508be500dea6e5732cc3d50382a0048b17e7b1`.

#### Scenario: Quickshell commit does not match
- **WHEN** the build resolves the Quickshell version tag to a commit that differs from the pinned commit
- **THEN** the build stops with an error that names Quickshell
- **AND** no image is tagged

### Requirement: aquamarine source pin
The development image SHALL build aquamarine 0.16.0 from commit `b77d67648336223a6c8fb88844ae316e7b72b574`.

#### Scenario: aquamarine commit does not match
- **WHEN** the build resolves the aquamarine version tag to a commit that differs from the pinned commit
- **THEN** the build stops with an error that names aquamarine
- **AND** no image is tagged

### Requirement: hyprutils source pin
The development image SHALL build hyprutils 0.14.3 from commit `0d13d5a624eb093b600d1b2cbe448fb613c86424`.

#### Scenario: hyprutils commit does not match
- **WHEN** the build resolves the hyprutils version tag to a commit that differs from the pinned commit
- **THEN** the build stops with an error that names hyprutils
- **AND** no image is tagged

### Requirement: hyprgraphics source pin
The development image SHALL build hyprgraphics 0.6.0 from commit `ade4ef0a887d2740efb9c9af2ddb175633365e1b`.

#### Scenario: hyprgraphics commit does not match
- **WHEN** the build resolves the hyprgraphics version tag to a commit that differs from the pinned commit
- **THEN** the build stops with an error that names hyprgraphics
- **AND** no image is tagged

### Requirement: hyprland-protocols source pin
The development image SHALL build hyprland-protocols 0.8.0 from commit `044a434ec371f985655389bcef09286b1af3d77c`.

#### Scenario: hyprland-protocols commit does not match
- **WHEN** the build resolves the hyprland-protocols version tag to a commit that differs from the pinned commit
- **THEN** the build stops with an error that names hyprland-protocols
- **AND** no image is tagged

### Requirement: hyprwire source pin
The development image SHALL build hyprwire 0.3.1 from commit `3e6865ce5fd9237b58f5b2ce5de18814df3baff5`.

#### Scenario: hyprwire commit does not match
- **WHEN** the build resolves the hyprwire version tag to a commit that differs from the pinned commit
- **THEN** the build stops with an error that names hyprwire
- **AND** no image is tagged

### Requirement: cpptrace source pin
The development image SHALL build cpptrace 1.0.4 from commit `3db8da80111171c219ab5839905771386bee06b3`.

#### Scenario: cpptrace commit does not match
- **WHEN** the build resolves the cpptrace version tag to a commit that differs from the pinned commit
- **THEN** the build stops with an error that names cpptrace
- **AND** no image is tagged

### Requirement: wayland source pin
The development image SHALL build wayland 1.25.0 from commit `3e673a438b0a9749e3bdf5cac4befac86333024c`.

#### Scenario: wayland commit does not match
- **WHEN** the build resolves the wayland version tag to a commit that differs from the pinned commit
- **THEN** the build stops with an error that names wayland
- **AND** no image is tagged

### Requirement: wayland-protocols source pin
The development image SHALL build wayland-protocols 1.49 from commit `ee78491a237eaff9389a0ccf8680521d074407d3`.

#### Scenario: wayland-protocols commit does not match
- **WHEN** the build resolves the wayland-protocols version tag to a commit that differs from the pinned commit
- **THEN** the build stops with an error that names wayland-protocols
- **AND** no image is tagged

### Requirement: Start container and nested Hyprland
One documented host command SHALL start the development container.
The same command SHALL start a nested Hyprland that appears as a separate window
in the current host desktop.
It SHALL NOT replace or change the active host desktop session.

#### Scenario: Normal start
- **WHEN** the developer runs the start command from a host Wayland session
- **THEN** the container runs
- **AND** a new Hyprland window appears on the host desktop
- **AND** the host bar and other host windows stay as they were

#### Scenario: Session already running
- **WHEN** the start command runs while a nested Hyprland is still alive
- **THEN** it reports that a session is already running
- **AND** it does not delete the session folder
- **AND** it does not start a second Hyprland

#### Scenario: Hyprland does not come up
- **WHEN** no Hyprland instance appears within the wait time
- **THEN** the command exits with an error
- **AND** it shows the end of the Hyprland log

### Requirement: Start the fixture window
The normal start command SHALL start the minimal Quickshell fixture inside the nested Hyprland,
right after the nested Hyprland starts. No separate step is needed.
A documented fixture command SHALL also start it on its own.
The fixture window SHALL be titled `phosphor-dev-fixture`.
It SHALL show a network line and a sound line.

#### Scenario: Fixture starts with the normal start
- **WHEN** the developer runs the start command
- **THEN** after the nested Hyprland starts, a window titled `phosphor-dev-fixture` appears inside it

#### Scenario: Fixture starts
- **WHEN** the developer runs the fixture command while the nested session runs
- **THEN** a window titled `phosphor-dev-fixture` appears inside the nested Hyprland
- **AND** it shows the host network devices and the default sound output

#### Scenario: No nested session
- **WHEN** the fixture command runs and no nested Hyprland is running
- **THEN** it exits with an error that says the session is not running

### Requirement: Check the session state
One documented command SHALL check audio, network and the fixture window.
It SHALL print one result line for each check.
It SHALL exit with an error if any check fails.

#### Scenario: All checks pass
- **WHEN** host audio and NetworkManager answer and the fixture window is open
- **THEN** each line reports success
- **AND** the command exits with success

#### Scenario: One check fails
- **WHEN** audio, NetworkManager or the fixture window is not available
- **THEN** the failing line names the problem
- **AND** the command exits with an error

#### Scenario: Limits of the check
- **WHEN** the check passes
- **THEN** this proves the audio server answers, not that sound is heard

### Requirement: Stop the nested session
One documented command SHALL stop the Hyprland launcher, Hyprland and the fixture.
It SHALL remove the session folder only after none of them is running.
It SHALL NOT stop host services.

#### Scenario: Clean stop
- **WHEN** the developer runs the stop command
- **THEN** no launcher, Hyprland or Quickshell process from the session remains
- **AND** the session folder is removed
- **AND** the nested window closes on the host

#### Scenario: A process survives
- **WHEN** any session process is still alive after the wait time
- **THEN** the command lists it and exits with an error
- **AND** it keeps the session folder

#### Scenario: Logs after stop
- **WHEN** the session has stopped
- **THEN** the Hyprland and Quickshell logs are still readable at the documented place

### Requirement: Host services through sockets
The container SHALL reach host NetworkManager, PipeWire, PulseAudio, D-Bus and Wayland
only through mounted host sockets.
The container SHALL NOT run its own NetworkManager, PipeWire or D-Bus daemon.

#### Scenario: Read host network state
- **WHEN** a network client runs inside the container
- **THEN** it shows the state of the host NetworkManager

#### Scenario: No service daemons
- **WHEN** the session is running
- **THEN** no NetworkManager, PipeWire or D-Bus daemon process runs inside the container

### Requirement: Secrets stay out of the image and the repo
The start command SHALL read the OpenCode API keys `OPENROUTER_API_KEY` and
`GITHUB_PERSONAL_ACCESS_TOKEN` from the host keyring, by name.
The lookup names MAY be in the repo; the key values SHALL NOT.
The keys SHALL NOT be written to any file or to the image.

#### Scenario: No key values in the repo
- **WHEN** the repo, including `dev/`, is searched for key values
- **THEN** none is found

### Requirement: Keys reach only the final shell
The start command SHALL pass the keys only to the shells it opens in the container
(the final shell, or the shell opened with `--shell`).
The keys SHALL NOT be in the container definition (`dev/devcontainer.json`)
or in the container's environment at creation.
The start command SHALL NOT print key values.

#### Scenario: Keys present
- **WHEN** both keys are found in the host keyring and the start command runs
- **THEN** OpenCode started from the final shell can read them
- **AND** no key value appears in the command output

#### Scenario: Later shell
- **WHEN** a new shell is opened in the container after start, not by the start command
- **THEN** it does not have the keys

#### Scenario: Keys missing
- **WHEN** a key is not found in the host keyring
- **THEN** the start command warns and the session still starts

### Requirement: Shell with keys on demand
The host script SHALL open a shell with the keys without starting anything when given `--shell`.

#### Scenario: Container running
- **WHEN** the container is running and the developer runs the start command with `--shell`
- **THEN** a shell opens in the container with both keys
- **AND** no key value is printed

#### Scenario: Container not running
- **WHEN** the container is not running and the developer runs the start command with `--shell`
- **THEN** it prints an error and exits non-zero
- **AND** nothing is started

### Requirement: Development guide
`docs/development.md` SHALL record the host prerequisites, build, start, fixture,
check and stop commands, log locations, known limitations and the verified host (NixOS 26.05).
It SHALL mark manual checks as manual.
It SHALL list only commands that were run and worked.

#### Scenario: Guide is complete
- **WHEN** a developer reads `docs/development.md`
- **THEN** they find each command, where it runs (host or container) and its expected result
- **AND** each manual check is labelled as manual
