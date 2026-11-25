## phosphor
A simple quickshell UI for hyprland

## Status

Development environment implementation is in progress; no product UI or tests are implemented yet.

## Project documentation

- [Product principles and constraints](docs/constitution.md)
- [Development, execution and verification](docs/development.md)
- [Contribution conventions](CONTRIBUTING.md)
- [Agent instructions and SDD workflow](AGENTS.md)

## Specification-driven development

OpenSpec 2.0.0 is installed and initialized for OpenCode. `openspec/specs/` holds
capability contracts and `openspec/changes/` holds active changes and their archive.
No capability specifications or changes exist yet.

All changes use the packaged `spec-driven` schema. Each change starts with an investigation.
Small, clearly bounded work may skip it, with user approval.
Unchanged contracts use `skip_specs: true`, not invented deltas.
See `AGENTS.md` for agent procedures/types and `CONTRIBUTING.md` for shared conventions.
Issues are optional tracking references.

## Planned repo structure

```text
phosphor
├── shell.qml
├── core/
├── services/
├── components/
├── modules/
├── assets/
├── dev/
│   ├── hyprland/
│   ├── scripts/
│   └── README.md
├── .gitignore
└── README.md
```
