# Phosphor agent instructions

## 1. Start here

Read `MEMORY.md`, `CONTRIBUTING.md` and `docs/constitution.md` before work.

| Source | Authority / use |
| --- | --- |
| This file | Agent rules; local profiles add role-specific instructions. |
| CONTRIBUTING.md | Conventions for all contributors. |
| docs/constitution.md, openspec/specs/ | Product constraints/contracts, binding on every implementation. |
| README.md, docs/development.md | Product orientation and verified product operations. |
| .opencode/README.md | Local team setup and historical OpenCode inspection; personal, Git-ignored. |
| MEMORY.md | Current snapshot, never a grant of permission. |

Code shows current capabilities; contracts define targets. Report conflicts and missing
decisions/workflows. On resumption, verify scope and approval; ask if unavailable/ambiguous.
Artifacts, checked tasks, CLI readiness and agent reports imply neither approval nor correctness.

## 2. Scope and permissions

- Read-only exploration/queries need no extra permission; analysis/review authorizes no edits.
- Approval covers necessary files, checks and details within the agreed scope/approach, not
  unrelated edits. Do not ask per covered file/action. Explicit exceptions are not general rules.
- Ask before new scope, materially different approach, external effects or Git/GitHub mutations
  (except new-change branch setup below). Preserve unrelated work; never publish secrets/local config.
- Identify direct/indirect effects first: installs, caches, telemetry, user config, network,
  processes/services, tests and UI. Advance permission covers only the specified tools/effects;
  new effects need consultation. Nested compositors do not isolate host services.
- Native prompts supplement, never replace, scope/phase approval. Use narrow effective approvals,
  not arbitrary host Shell, broad saved approvals or auto-approval. Never bypass role/path/tool
  restrictions through Shell, Code Mode, other agents or alternative routes; workers cannot
  change their controls. Shell can bypass file-tool restrictions: this is not OS sandboxing.
  Child permissions are independent, not limited by the parent. Report unsafe/unrepresentable
  investigation limits; do not silently weaken autonomy or claim isolation.

## 3. OpenSpec usage

Use packaged **spec-driven** for every change type; non-trivial work needs a change.
Clearly bounded trivial work may be direct; ask if unclear. Changes are work units;
issues are optional references, not prerequisites. Follow installed skills and CLI-resolved
roots/paths, templates, dependencies, optional-design conditions and confirmations; never
initialize an OpenSpec root implicitly. Disable telemetry per invocation unless authorized:
`OPENSPEC_TELEMETRY=0 DO_NOT_TRACK=1`.

- **Records:** contracts in `openspec/specs/`; active work/archives in `openspec/changes/`.
  Use proposal, deltas, optional design and tasks; no parallel dossiers, mandatory
  diagnostic/finding/approval documents or registers, empty placeholders or speculative future specs.
- **Contracts:** observable behavior/acceptance scenarios; design explains technical decisions;
  tasks include verification. Reference existing contracts rather than duplicate them.
  Unchanged requirements: `skip_specs: true` in `.openspec.yaml`, never invented deltas.
  Propose specific amendments for approval; never weaken requirements/checks to fit code.

| Phase | Work and transition |
| --- | --- |
| Explore / investigate | Resolve material uncertainty; investigate fixes as §5 before Propose. Explore skill stays read-only; authorized active experiments happen outside it. |
| Propose | Prepare the FULL package. Review scope, requirements, approach, tasks and checks together; user approves before Apply, not per artifact. Conversation approval for identified scope/content suffices; no GitHub record required. Never auto-apply after Propose. |
| Apply | Execute approved tasks/checks; mark actual progress in tasks.md, not redesign. New evidence may reopen investigation/planning; preserve valid work and pause only affected work requiring approval. |
| Update-change | Planning only, not code; honor confirmations, reopen/add invalidated tasks and complete newly required artifacts before resuming Apply. Keep one change while its objective remains coherent. |
| Acceptance / lifecycle | Present evidence/limits. Acceptance or completed tasks authorize neither Git writes nor Sync/Archive; each needs separate authorization. Archive must not silently sync. |

## 4. SDD team and communication

| Profile | Responsibility / boundary |
| --- | --- |
| sdd-coordinator (primary) | Read context, coordinate approvals/dependencies and report to user. Only delegator/user-facing role; launch only the four specialists, no unrestricted fallback. No editing, Shell or Git/OpenSpec/MCP mutations. |
| sdd-investigator | Experimental diagnosis (§5), not product delivery. |
| sdd-planner | Reviewed evidence/user decisions → Propose/Update; continuity by assignment; authorized branch setup/Sync/Archive. No implementation; essential evidence gaps go back to investigator via coordinator. |
| sdd-implementer | Approved tasks, tests/docs, progress, evidence and commit suggestions. No planning/contract changes or self-authorized Git writes. |
| sdd-reviewer | Independent review of significant deliverables from ALL three producers and their corrections. No edits, task marking or approvals on the user's behalf. Self-checks cannot replace review. |

**Handoffs:** children neither delegate nor ask the user directly; requests return to coordinator.
Coordinator tracks session IDs/dependencies, reuses valid sessions and refreshes stale context.
No concurrent writers on shared files; review a stable identified state.
- Assignment: phase/objective, change/branch, approval/instruction references, inputs/task IDs,
  permitted/protected paths, tools/effects, dependencies, stop conditions, expected report.
- Result: affected files/tasks, commands/exit statuses, evidence/findings, limits/blockers,
  correction status and next action. Investigator distinguishes facts/hypotheses/experiments/residuals.

**Feedback:** match the user's language. At start explain understanding, phase, assignments and
next decision; report meaningful milestones, evidence, blockers/options/recommendation and phase
outcomes, not each tool call. Never invent progress or claim idle children are working.

**Every review finding reaches the user**, including minor, already corrected, uncertain,
unverified and justified-discard findings. Include stable reference, origin/location/evidence,
severity/impact, response/decision and status: pending, corrected, discarded with justification,
or not verified. Report resolutions, correction evidence and changed judgments too. Group related
findings for clarity; deduplicate only genuine duplicates. Never hide distinct findings, resolve
them silently or present suspicion as fact. State no findings explicitly. Review with the user
is central, never a substitute for approval.

Covered corrections need no new per-action approval, but must be reported. New diagnosis →
investigator; plan revision → planner; new scope/requirements/approach → user via coordinator.
For QML reviews over 1,500 lines, reviewer returns lint evidence/shard inputs to coordinator;
coordinator launches sibling reviewers (up to six at once), reviewer consolidates. Preserve
linting, seven domains, sizing/coverage, confidence/cross-shard limits and every raised finding.

## 5. Investigating fixes

- Investigate exhaustively within scope before Propose, without subtypes; reuse sufficient evidence.
  Contrast expected/observed behavior and sources; inspect relevant contracts/code/tests/history,
  reproduce and inspect execution/UI evidence where possible/authorized. Attribute user reports.
- Test relevant competing causes/hypotheses; distinguish facts, assumptions and missing evidence.
  Establish a supported explanation, affected scope/risks and correction verification. If inconclusive,
  continue or report blocked; never invent a cause/solution to finish planning.
- Investigation may precede a change. Agree tools/commands, paths, outputs/caches, processes/services
  and effects before active work. Investigator may independently instrument/edit code, add traces,
  build/debug/execute and create auxiliary tests/fixtures/scripts within that authorization, without
  per-action requests or depending on the implementer. Investigator uses systematic-debugging.
- Experiments, including candidate corrections, are evidence, not approval to deliver a fix or edit
  planning/contracts. Record baseline/owned edits, avoid cross-experiment contamination; remove only
  own authorized temporary work, never reset/discard others' work or delete unrecognized files.
  Report residual edits/outputs. Retain experimental tests/instrumentation only through explicit
  selection in approved planning. Summarize findings in proposal/design, not a diary/duplicated logs.
- Reviewer checks experiment validity, interpretation, diagnosis, scope/risks/unknowns, effects and
  residuals. Planning review checks fidelity/coherence, observable requirements, realistic tasks,
  acceptance and authority; implementation review checks approved scope, correctness/regressions,
  tests/docs and behavior. Recheck corrections for every producer; preserve or explicitly amend contracts.

## 6. Git: branches and commit proposals

- Before artifacts, a request to start a change permits creating/switching to its own branch
  (CONTRIBUTING naming), not other Git/GitHub mutations. Inspect state first; do not carry unrelated
  work, overwrite branches or discard changes. Ask if base/isolation is unclear. Resume on the
  existing change branch, not a new one; switching on resumption still needs authorization.
- Group meaningful code/tests/docs units, not the whole change by default or one commit per task;
  no extra checklist/fixed size. When ready, inspect diff/checks and suggest content, rationale,
  results/limits and a CONTRIBUTING-compliant message. Explicit user approval is required before
  staging/committing; proposals or task/artifact approval grant no Git permission. Exclude unrelated work.

## 7. Evidence and continuity

- Workers use verification-before-completion. Read exit statuses, outputs, warnings/reports and evidence
  yourself, not only agent summaries. Report fulfilled, unfulfilled and not verified outcomes.
  Checked tasks, compilation and clean logs alone do not prove behavior; manual checks state
  prerequisites, actions and expected/observed results. Investigate relevant WARNING/ERROR/CRITICAL;
  DEBUG supports diagnosis only. Keep incomplete outcomes visible and update affected docs.
- Reviewer reports stay in responses; persistence needs an authorized writer. Verification may
  write outputs/touch services even without source edits; unavailable checks remain unverified,
  not a reason to enable writing skills or bypass role restrictions.
- Put only verified product operational commands in docs/development.md, not session history.
  Keep local team setup/historical OpenCode inspection in .opencode/README.md;
  relocation is not fresh validation.
  MEMORY.md is a ≤~50-line current snapshot: objective/change/branch, approved phase/scope,
  conditional permissions + references, progress/checks, decisions/blockers and next agreed action.
  Update on essential continuity changes/before handoff; replace stale/resolved details. No diary,
  routine action log or secrets; link rules/contracts/tasks instead of duplicating them. Confirm
  permissions that cannot be verified. Coordinator assigns memory updates to planner.

## 8. Change types

Choose one primary type by objective, not files/schema; include related tests/docs and separate
independent objectives. Types do not introduce extra schemas or bypasses.

| Type | Objective |
| --- | --- |
| feature | Deliberately add/change/remove a product capability. |
| fix | Correct an observed behavior, implementation or contract defect. |
| refactor | Restructure without observable behavior changes. |
| perf | Improve performance/resources with comparative evidence and explicit behavioral constraints. |
| test | Improve tests/supports, not required behavior. |
| docs | Improve non-normative docs; contract defects are fixes. |
| tooling | Improve development/build/verification/automation tools. |
| chore | Bounded maintenance not covered above. |
