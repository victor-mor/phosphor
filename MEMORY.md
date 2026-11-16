# Phosphor continuity

## Current state
- Branch: tooling/simpler-rules (from master). No OpenSpec change: direct setup work.
- One commit: `Simplify agent rules and add experiment folder` (rules simplified, roles and
  permissions clarified, `exp/` ignored). Not pushed.
- Local, Git-ignored profiles updated to match. .opencode/README.md removed.
- Open gap: no role may edit AGENTS.md or .opencode/; user must choose who does it.

## Conventions agreed
- Read-only actions are always allowed (AGENTS.md §2). GitHub queries not available to agents yet.
- Experiments only in `exp/<name>/`, one folder each (§5).
- Explanations and planning artifacts are short, simple and didactic (§3, §4).
- After approval, the implementer commits (§6) and does small direct work (§3).

## Product status
- Setup only: no QML/runtime, tests or verified runtime commands. OpenSpec 2.0.0 via Nix,
  spec-driven schema only; no active changes or specs.
- Undecided/unscoped: state ownership, state machine, wiring, persistence/IPC, locale fallback,
  plugins, visual/interaction contracts, developer mode beyond DEBUG.

## Unverified
- Runtime enforcement of profiles (read-only Shell rules, `exp/*` limit), default agent selection,
  end-to-end SDD, QML sharding. Runtime checks need separate approval and use ignored
  `test-results/sdd-agents/`.

## Next
- User approves the commit. Then a real test with a small task, and the first product objective.
