# Phosphor agent rules

Write short sentences in plain words.

## 1. Start
- First read MEMORY.md, CONTRIBUTING.md and docs/constitution.md.
- Sources:
  - AGENTS.md: rules for agents. Each profile adds rules for its own role.
  - CONTRIBUTING.md: conventions for everyone.
  - docs/constitution.md + openspec/specs/: product rules. These are binding.
  - README.md, docs/development.md: product overview and verified commands.
  - MEMORY.md: current state. It never grants permission.
- Code shows what exists today. Contracts set the target. Report conflicts and gaps.
- When resuming, confirm the scope and approval. If they are unclear, ask.
- Artifacts, checked tasks and agent reports prove neither approval nor correctness.

## 2. Permissions
- Read-only actions are always allowed, for every role. Examples: reading files, searching,
  git status/diff/log/show, cat, ls, rg, openspec list/status/show, web and Qt docs queries.
  Anything that writes, starts processes or changes state is not read-only.
- GitHub queries are not available to agents yet: the GitHub tools can also write.
- An approval covers everything needed inside the agreed scope. Don't ask for each file.
- Ask before new scope, a different approach, external effects, or Git/GitHub writes
  (creating the change branch is the exception, see §6).
- Before acting, list the side effects: installs, caches, network, user config, services, UI.
  An approval covers only the effects it names.
- Never publish secrets or local config. Leave unrelated work untouched.
- Never bypass a restriction through Shell, Code Mode or other agents. Shell is not a sandbox.
  A nested desktop session still shares the host's services. Report your limits; never claim isolation.

## 3. OpenSpec
- Non-trivial work needs a change (spec-driven schema). Small, clearly bounded work can be
  done directly, without a change, if the user agrees. The implementer does it; the reviewer
  checks it. If unsure, ask.
- Use the installed skills and the CLI. Never initialize OpenSpec without being asked.
  Prefix commands with `OPENSPEC_TELEMETRY=0 DO_NOT_TRACK=1`.
- Contracts live in openspec/specs/. Changes and archives live in openspec/changes/.
- A change contains a proposal, spec deltas, an optional design and tasks. Nothing else.
  No extra documents, empty placeholders or speculative specs.
- Spec = observable behavior + scenarios. Design = the technical reasons. Tasks include verification.
- Write proposal, design, specs and tasks short and simple. Plain words, one idea per line,
  explain needed jargon. Keep what matters; cut the rest.
- No requirement changes: set `skip_specs: true`. Never weaken a requirement to fit the code;
  propose an amendment instead.

Phases:
1. Investigate: before planning, the investigator clears up doubts: bugs, feasibility, anything
   unclear (§5). Small, clearly bounded work may skip it, with user approval.
2. Propose: prepare the full package. The user approves it as a whole; approval in chat is enough.
   Never move on to Apply automatically.
3. Apply: carry out the approved tasks and tick real progress. New evidence can reopen planning.
   Pause only the affected work.
4. Update: planning only, no code. Keep the same change while its goal still holds.
5. Close: present evidence and limits. Commit, Sync and Archive each need separate approval.
   Archive never syncs silently.

## 4. Team
| Role | Does | Doesn't |
| --- | --- | --- |
| coordinator | talks to the user, delegates to the 4 specialists, tracks approvals | edit, write, mutate anything |
| investigator | investigates through experiments: bugs, feasibility, doubts (§5) | deliver fixes or product work |
| planner | writes and updates OpenSpec plans; creates the change branch; Sync/Archive when approved; updates MEMORY.md when the coordinator asks | implement |
| implementer | approved tasks and direct work, tests and docs; proposes commits and makes them once approved | change plans or contracts |
| reviewer | independently reviews the other three, including their corrections | edit, tick tasks, approve |

Handoffs:
- Only the coordinator delegates or talks to the user.
- The coordinator tracks sessions. One writer per file at a time. Reviews use a stable state.
- An assignment states: goal and phase, change/branch, approvals, inputs and tasks,
  allowed paths, tools and effects, when to stop, and the expected report.
- A report states: files and tasks touched, commands with exit status, evidence,
  limits and blockers, next step. The investigator keeps facts and hypotheses apart.

Talking to the user:
- Use the user's language. Be short, simple and clear. Explain jargon; never assume knowledge.
- At the start, say: what you understood, the phase, who does what, and the next decision.
  After that, report only milestones, blockers, and options with a recommendation.
- Never invent progress.

Review findings:
- Every finding reaches the user, including minor, already fixed or discarded ones.
- For each one, give: an id, the location, the evidence, the severity, the decision and the status
  (pending / corrected / discarded + reason / not verified).
- If there are no findings, say so. Never present a suspicion as a fact.
- Corrections within scope need no new approval, but they are reported.
  New doubts or diagnosis → investigator. Plan changes → planner. New scope → user.
- QML reviews over 1,500 lines: the reviewer gives lint results and shards to the coordinator.
  The coordinator launches up to 6 sibling reviewers. One reviewer merges the results.
  Keep all 7 domains and every finding.

## 5. Investigation
- Before planning: read the contracts, code, tests and history. For bugs, compare expected
  and observed behavior and reproduce the problem if possible.
- Test competing causes or options. Keep facts, assumptions and unknowns apart.
  If the result is inconclusive, keep going or report that you are blocked.
  Never invent a cause or a result.
- Agree on tools, paths and effects first. Within that agreement, work freely without asking
  for each action. Use systematic-debugging for bugs.
- Experiments go only in `exp/<name>/`, one folder per experiment (ignored by Git).
  Never edit product files to experiment; copy what you need into the folder.
- An experiment is evidence, not approved work. Clean only your own folder and report what
  remains. Keeping anything requires approved planning. Summarize in the proposal or design;
  no diaries.
- The reviewer checks experiments and findings; plans (coherence, testable tasks); and code
  (scope, correctness, tests, docs).

## 6. Git
- Starting a change allows creating or switching to its branch (naming per CONTRIBUTING),
  and nothing else. Check the state first; don't carry over or lose other work.
  Resume on the existing branch.
- Commits group meaningful units. The implementer proposes the content, reasons, checks and message.
- Staging or committing always needs explicit approval from the user. Once approved,
  the implementer stages and commits exactly that. Push and PRs need their own approval.

## 7. Evidence and memory
- Use verification-before-completion. Read the outputs yourself.
  Report what is done, not done and not verified.
- Compiling or ticking a task is not proof. A manual check states the prerequisites, the steps,
  and the expected vs observed result.
- Investigate WARNING/ERROR/CRITICAL logs.
- Reviewer reports stay in the chat unless a writer is authorized.
- docs/development.md holds only verified product commands.
- MEMORY.md has at most ~50 lines: goal, branch, scope, permissions, progress, decisions,
  blockers and next step. No diary, no secrets.
  The coordinator asks the planner to update it after every state change (decision, approval,
  milestone, blocker) and before a session ends. No extra approval is needed.

## 8. Change types
Pick one per change: feature, fix, refactor, perf (with measurements), test, docs, tooling, chore.
A contract defect counts as a fix.
