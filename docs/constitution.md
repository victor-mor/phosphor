# Phosphor constitution

Approved product principles and constraints. These apply to specifications and implementations regardless of whether a human or agent performs the work. They describe the target, not existing capabilities; inclusion does not schedule a feature.

## Technical foundation
- Phosphor is a Quickshell (Qt Quick/QML) UI for Hyprland.
- Changes must remain compatible with the MIT license in `LICENSE`.
- Project-owned variables, IDs and functions use snake_case where QML permits it; external APIs and QML type/component naming requirements take precedence.

## Architectural responsibilities
- `shell.qml`: intended entrypoint for shell composition and startup.
- `core/`: shell-wide coordination/state machine, persistent preferences (themes, fonts, settings) and IPC handling.
- `services/`: system integrations such as audio, network, Bluetooth and power, potentially through external tools.
- `components/`: reusable visual elements and interaction callbacks.
- `modules/`: usable shell features composed from components and, where needed, other modules.
- `assets/`: shared graphical resources.
- `dev/`: controlled launch/debug environment, separate from runtime UI functionality.
- These boundaries do not settle state ownership, dependency direction or component/service wiring; those contracts remain to be agreed before affected implementation.

## Cross-cutting product requirements
- Use system locales for language and region; translations and fallback behavior require a concrete specification.
- Provide INFO, DEBUG, WARNING, ERROR and CRITICAL logging levels.
- Provide normal and developer modes: developer mode enables DEBUG logging; normal mode disables it.
- Integrate with external tools for system services; concrete providers are selected per feature.
- Plugin support is an intended capability, not a defined extension API. Its contract and scope remain pending.
- Feature specifications must define observable acceptance criteria and applicable unavailable-service, pending-operation and failure behavior. Absence of log errors alone is not evidence of functional correctness.
