# Contributing to Phosphor

Conventions for all contributors, with or without AI. Agent procedures: `AGENTS.md`.

## Project references
- [Product constraints](docs/constitution.md); capability contracts in `openspec/specs/` as specified.
- [Development and verification](docs/development.md); [status and planned structure](README.md).

## Contributions
- Keep scope focused and unrelated work separate; preserve other contributors' changes.
- Discuss unclear behavior, compatibility and significant design decisions before implementation.
  Respect contracts and make proposed amendments explicit.
- Include relevant tests/docs. Report actual checks, results, limitations and unverified
  outcomes; include useful screenshots for visual changes.
- Issues are optional for reporting/tracking, not prerequisites for edits. Reference
  relevant issues without copying their content.

## OpenSpec
- Use OpenSpec for non-trivial contributions, with or without AI. Clearly bounded
  trivial edits do not require a change.
- Version `openspec/` configuration, specs, change artifacts and archives alongside
  the related implementation; these are shared project records, not disposable outputs.
- Use any assistant or work manually. `.opencode/` and `opencode.json` are shared setup.
  `.agents/`, `opencode.jsonc` and `skills-lock.json` stay personal and ignored.
  Never commit secrets. Shared agent instructions remain in `AGENTS.md`.

## Git conventions
### Commits
- Keep commits small, coherent and independently reviewable/revertible, with relevant
  tests/docs. A change may span several commits; avoid both giant commits and artificial
  fragmentation. Group meaningful work, not unrelated edits or one commit per task.
- Imperative description, initial capital, normal sentence casing; aim for ≤50 subject
  characters, without type/scope prefix. Add `(#N)` only when there is a corresponding issue.
- Examples: `Add nested session launcher (#1)`, `Correct development guide`.
- Use non-closing references unless closure is explicitly intended and delivery complete.

### Branches
- `<type>/<short-description>`; lowercase description, at most two hyphen-separated words.
- Examples: `feature/audio-service`, `fix/workspace-switching`. Type catalog: AGENTS.md;
  no AI workflow is required to contribute.

### Pull requests
- One coherent objective per PR and one branch per PR. Include descriptive title,
  summary, relevant issue links if any, actual verification and known limitations.
- Partial delivery or merge does not by itself complete a tracked issue.

## Repository hygiene
Version shared instructions, contracts and useful docs, never credentials, personal or
machine-local configuration, caches or generated outputs.
