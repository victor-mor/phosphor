## ADDED Requirements

### Requirement: Hyprland source pin
The development image SHALL build Hyprland 0.57.2 from commit `11cbc6c577b84ffb1edf4df3fc5b6128c3ae6947`.

#### Scenario: Hyprland commit does not match
- **WHEN** the Hyprland source checked out during the build is not at its fixed commit
- **THEN** the build stops with an error that names Hyprland
- **AND** no image is tagged

### Requirement: Quickshell source pin
The development image SHALL build Quickshell 0.3.2 from commit `4f508be500dea6e5732cc3d50382a0048b17e7b1`.

#### Scenario: Quickshell commit does not match
- **WHEN** the Quickshell source checked out during the build is not at its fixed commit
- **THEN** the build stops with an error that names Quickshell
- **AND** no image is tagged

### Requirement: aquamarine source pin
The development image SHALL build aquamarine 0.16.0 from commit `b77d67648336223a6c8fb88844ae316e7b72b574`.

#### Scenario: aquamarine commit does not match
- **WHEN** the aquamarine source checked out during the build is not at its fixed commit
- **THEN** the build stops with an error that names aquamarine
- **AND** no image is tagged

### Requirement: hyprutils source pin
The development image SHALL build hyprutils 0.14.3 from commit `0d13d5a624eb093b600d1b2cbe448fb613c86424`.

#### Scenario: hyprutils commit does not match
- **WHEN** the hyprutils source checked out during the build is not at its fixed commit
- **THEN** the build stops with an error that names hyprutils
- **AND** no image is tagged

### Requirement: hyprgraphics source pin
The development image SHALL build hyprgraphics 0.6.0 from commit `ade4ef0a887d2740efb9c9af2ddb175633365e1b`.

#### Scenario: hyprgraphics commit does not match
- **WHEN** the hyprgraphics source checked out during the build is not at its fixed commit
- **THEN** the build stops with an error that names hyprgraphics
- **AND** no image is tagged

### Requirement: hyprland-protocols source pin
The development image SHALL build hyprland-protocols 0.8.0 from commit `044a434ec371f985655389bcef09286b1af3d77c`.

#### Scenario: hyprland-protocols commit does not match
- **WHEN** the hyprland-protocols source checked out during the build is not at its fixed commit
- **THEN** the build stops with an error that names hyprland-protocols
- **AND** no image is tagged

### Requirement: hyprwire source pin
The development image SHALL build hyprwire 0.3.1 from commit `3e6865ce5fd9237b58f5b2ce5de18814df3baff5`.

#### Scenario: hyprwire commit does not match
- **WHEN** the hyprwire source checked out during the build is not at its fixed commit
- **THEN** the build stops with an error that names hyprwire
- **AND** no image is tagged

### Requirement: cpptrace source pin
The development image SHALL build cpptrace 1.0.4 from commit `3db8da80111171c219ab5839905771386bee06b3`.

#### Scenario: cpptrace commit does not match
- **WHEN** the cpptrace source checked out during the build is not at its fixed commit
- **THEN** the build stops with an error that names cpptrace
- **AND** no image is tagged

### Requirement: wayland source pin
The development image SHALL build wayland 1.25.0 from commit `3e673a438b0a9749e3bdf5cac4befac86333024c`.

#### Scenario: wayland commit does not match
- **WHEN** the wayland source checked out during the build is not at its fixed commit
- **THEN** the build stops with an error that names wayland
- **AND** no image is tagged

### Requirement: wayland-protocols source pin
The development image SHALL build wayland-protocols 1.49 from commit `ee78491a237eaff9389a0ccf8680521d074407d3`.

#### Scenario: wayland-protocols commit does not match
- **WHEN** the wayland-protocols source checked out during the build is not at its fixed commit
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
One documented command SHALL start the minimal Quickshell fixture inside the nested Hyprland.
The fixture window SHALL be titled `phosphor-dev-fixture`.
It SHALL show a network line and a sound line.

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
API keys for OpenCode SHALL reach the container only at start time.
The start command SHALL pass only keys already set in the host environment.
They SHALL NOT be written to any file or to the image.

#### Scenario: Keys present
- **WHEN** the keys are set in the host environment and the start command runs
- **THEN** OpenCode inside the container can read them

#### Scenario: Keys missing
- **WHEN** a key is not set
- **THEN** the start command warns and the session still starts

### Requirement: OpenCode editor extension
The dev container SHALL list the extension `sst-dev.opencode` for VS Code and VSCodium clients.

#### Scenario: Open from VSCodium
- **WHEN** the user opens the dev container from VSCodium
- **THEN** the extension `sst-dev.opencode` is installed and active in the container

### Requirement: Development guide
`docs/development.md` SHALL record the host prerequisites, build, start, fixture,
check and stop commands, log locations, known limitations and the verified host (NixOS 26.05).
It SHALL mark manual checks as manual.
It SHALL list only commands that were run and worked.

#### Scenario: Guide is complete
- **WHEN** a developer reads `docs/development.md`
- **THEN** they find each command, where it runs (host or container) and its expected result
- **AND** each manual check is labelled as manual
