# Phosphor continuity

## Objective and authority
- Branch: tooling/project-setup. Organize existing setup work into coherent commits, each requiring
  individual user approval. Direct setup without a change is a one-off exception, not general SDD policy;
  no new OpenSpec change artifacts authorized.
- First unit individually approved and committed: 8a6bc73, `Initialize OpenSpec and repository hygiene`.
  Reported checks confirmed exactly .gitignore, openspec/config.yaml, openspec/specs/.gitkeep and
  openspec/changes/archive/.gitkeep; cached diff check clean, show/stat confirmed.
- User explicitly authorized (“Lo autorizo”) staging+commit ONLY README.md, CONTRIBUTING.md,
  docs/constitution.md, docs/development.md, AGENTS.md, MEMORY.md as the second unit;
  message `Document project foundations and SDD workflow`. Commit not yet recorded as created.
  Permission covers this single creation, consumed when committed; no push, Sync/Archive or other Git writes.
- No installs, host-service changes or active runtime sessions/fixtures authorized. Worker Shell/external
  access needs native approval; no investigation execution envelope enabled. Conversation does not
  override tool denies. Every review finding/disposition must reach the user.

## Documentation and local agents
- AGENTS.md owns shared agent rules; CONTRIBUTING.md human/agent contribution conventions;
  docs/constitution.md product constraints; README.md status/planned structure.
- Product-only, agent/AI-neutral docs/development.md and ignored local .opencode/README.md are separated,
  applied and independently reviewed. The latter preserves local setup/historical inspection, not runtime proof.
- Local five-role profiles/config/QML adapter are personal, ignored, excluded from commits and not restored
  by clone. Controls unchanged; implementer denies on AGENTS.md/.opencode remain.
- Historical OpenCode v2.2.7 inspection: native discovery and 98 static permission assertions passed;
  config sets coordinator default. These results are not fresh validation or runtime enforcement evidence.
- UNVERIFIED: actual default selection, runtime enforcement, no-prompt investigation, review/correction
  communication, QML sharding and end-to-end SDD. Runtime checks need separate bounded effects approval;
  use ignored test-results/sdd-agents/, not protected .opencode/. Prior tools: Python3/cc, no gdb/make.

## Product status and next action
- Setup only: no QML/runtime, launch environment/tests or verified runtime commands.
  OpenSpec 2.0.0 via Nix, initialized for OpenCode, packaged spec-driven only; no active changes/specs.
  Verify packages/nested Hyprland/focused checks before runnable claims; other environments undefined.
- Agree type-specific details without invented gates; state ownership (shared/per-service), central
  state machine, component/service wiring, confirmed/pending state/failures, persistence/IPC, locale
  fallback, plugins, visual/interaction contracts and developer mode beyond DEBUG remain undecided/unscoped.
- Next after closing the authorized unit: agree a first product/tooling objective or bounded active
  validation and its effects. Neither is authorized here; planner updates continuity.
