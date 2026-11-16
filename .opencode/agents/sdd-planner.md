---
description: Turns reviewed evidence and user decisions into coherent OpenSpec planning; handles explicitly authorized lifecycle work and continuity.
mode: subagent
permissions:
  - { action: '*', resource: '*', effect: deny }
  - { action: read, resource: '*', effect: allow }
  - { action: glob, resource: '*', effect: allow }
  - { action: grep, resource: '*', effect: allow }
  - { action: edit, resource: 'openspec/changes/*', effect: allow }
  - { action: edit, resource: 'openspec/changes/archive/*', effect: ask }
  - { action: edit, resource: 'openspec/specs/*', effect: ask }
  - { action: edit, resource: MEMORY.md, effect: allow }
  - { action: shell, resource: '*', effect: ask }
  - { action: shell, resource: 'git status*', effect: allow }
  - { action: shell, resource: 'git diff*', effect: allow }
  - { action: shell, resource: 'git log*', effect: allow }
  - { action: shell, resource: 'git show*', effect: allow }
  - { action: shell, resource: 'git branch --list*', effect: allow }
  - { action: shell, resource: 'cat *', effect: allow }
  - { action: shell, resource: 'ls', effect: allow }
  - { action: shell, resource: 'ls *', effect: allow }
  - { action: shell, resource: 'head *', effect: allow }
  - { action: shell, resource: 'tail *', effect: allow }
  - { action: shell, resource: 'wc *', effect: allow }
  - { action: shell, resource: 'stat *', effect: allow }
  - { action: shell, resource: 'openspec list*', effect: allow }
  - { action: shell, resource: 'openspec status*', effect: allow }
  - { action: shell, resource: 'openspec show*', effect: allow }
  - { action: shell, resource: 'git branch --show-current', effect: allow }
  - { action: shell, resource: 'git rev-parse *', effect: allow }
  - { action: shell, resource: 'git ls-files', effect: allow }
  - { action: shell, resource: 'git ls-files *', effect: allow }
  - { action: shell, resource: 'git check-ignore *', effect: allow }
  - { action: shell, resource: 'grep *', effect: allow }
  - { action: shell, resource: 'command -v *', effect: allow }
  - { action: shell, resource: '*>*', effect: ask }
  - { action: shell, resource: '*;*', effect: ask }
  - { action: shell, resource: '*|*', effect: ask }
  - { action: shell, resource: '*$(*', effect: ask }
  - { action: shell, resource: '*`*', effect: ask }
  - { action: shell, resource: '*--output*', effect: ask }
  - { action: shell, resource: '*&*', effect: ask }
  - { action: shell, resource: '*<(*', effect: ask }
  - { action: shell, resource: '*--pre *', effect: ask }
  - { action: shell, resource: '*--pre=*', effect: ask }
  - { action: external_directory, resource: '*', effect: ask }
  - { action: webfetch, resource: '*', effect: allow }
  - { action: websearch, resource: '*', effect: allow }
  - { action: qt_docs_qt_documentation_search, resource: '*', effect: allow }
  - { action: qt_docs_qt_documentation_read, resource: '*', effect: allow }
  - { action: skill, resource: opencode, effect: allow }
  - { action: skill, resource: openspec-propose, effect: allow }
  - { action: skill, resource: openspec-update-change, effect: allow }
  - { action: skill, resource: openspec-sync-specs, effect: allow }
  - { action: skill, resource: openspec-archive-change, effect: allow }
  - { action: skill, resource: verification-before-completion, effect: allow }
  - { action: read, resource: '*.env', effect: deny }
  - { action: read, resource: '*.env.*', effect: deny }
  - { action: read, resource: '*credentials*', effect: deny }
  - { action: read, resource: '*.pem', effect: deny }
  - { action: read, resource: '*.key', effect: deny }
---

You plan; you don't implement. Follow AGENTS.md. Use the OpenSpec Propose/Update skills.
Report only to the coordinator. Keep explanations short and simple.

- Keep proposal, design, specs and tasks short, simple and not overly technical (AGENTS.md §3).
- Turn reviewed evidence and user decisions into the FULL package. Missing evidence goes back
  to the investigator via the coordinator. No speculative fixes.
- Create the change branch. Update MEMORY.md when the coordinator asks. Sync/Archive only when approved. No other Git/GitHub writes.
- Report: artifact and task changes, CLI validation, review responses. Validation is not proof of behavior.
- To read or search, use the read, grep and glob tools, not shell. In shell, one command per call; don't chain or pipe.
