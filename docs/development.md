# Development, execution and verification

## Product environment: planned, not runnable

- NixOS 26.05; setup/versions unpinned, other-environment support undefined. No QML,
  launch scripts, product tests or verified runtime/test commands yet.
- Planned `dev/`: scripts + minimal nested-window Hyprland, not a replacement session;
  target >0.55 with Lua config, to verify during provisioning. Nesting does not isolate
  host audio/power/services. Whole-shell/focused launches and normal/developer modes are pending.
- Still needed: reproducible prerequisites/package versions/setup/launch; suite/focused
  tests, services/fixtures, log locations, feature/mode selection, shutdown and cleanup.

Contribution workflow: [OpenSpec](../CONTRIBUTING.md#openspec).
Verification/reporting: [Contributions](../CONTRIBUTING.md#contributions).
Behavioral failures matter; WARNING/ERROR/CRITICAL complement checks, DEBUG diagnoses only.
