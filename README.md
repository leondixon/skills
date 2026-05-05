# Skills

My personal collection of Claude Code skills. Adapted from [mattpocock/skills](https://github.com/mattpocock/skills), evolving into my own.

## Quickstart

```bash
npx skills@latest add leondixon/skills -a claude-code -g
```

Pick which skills (and which agents) to install. The CLI reads `.claude-plugin/plugin.json` and links the selected skills into your agent's skills directory.

The `-a claude-code -g` flags target Claude Code's global layout (`~/.claude/`). Without them the CLI defaults to the tool-agnostic `~/.agents/` path. Drop `-g` for a project-level install (`./.claude/`).

After install, run `/setup-repo` once per repo to scaffold the per-project config (issue tracker, triage labels, domain doc layout) that the engineering skills consume.

## Local install

> **Claude Code only.** The script installs into `~/.claude/`, which is Claude Code's layout. Other tools (e.g. Cursor, Cline) are not supported — the script will prompt for confirmation and exit if you answer no.

If you've cloned this repo and want to symlink every skill and agent straight into `~/.claude/`:

```bash
./scripts/link-skills.sh
```

This links:
- `skills/**/SKILL.md` → `~/.claude/skills/<name>`
- `agents/*.md` → `~/.claude/agents/<name>.md`

Re-run any time. Existing real directories at the target are replaced by the symlink — see the script for details.

## Skills

### Engineering

- **[setup-repo](./skills/engineering/setup-repo/SKILL.md)** — Scaffold per-repo config (issue tracker, triage labels, domain doc layout) that the other engineering skills consume. Run once per repo.
- **[socratic-with-docs](./skills/engineering/socratic-with-docs/SKILL.md)** — Socratic session that challenges your plan against the existing domain model, sharpens terminology, and updates `CONTEXT.md` and ADRs inline.
- **[tdd](./skills/engineering/tdd/SKILL.md)** — Test-driven development with a red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time.
- **[diagnose](./skills/engineering/diagnose/SKILL.md)** — Disciplined diagnosis loop for hard bugs and performance regressions: reproduce → minimise → hypothesise → instrument → fix → regression-test.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** — Find deepening opportunities in a codebase, informed by `CONTEXT.md` and `docs/adr/`.
- **[zoom-out](./skills/engineering/zoom-out/SKILL.md)** — Tell the agent to zoom out and give broader context or a higher-level perspective on an unfamiliar section of code.
- **[triage](./skills/engineering/triage/SKILL.md)** — Triage issues through a state machine of triage roles.
- **[to-prd](./skills/engineering/to-prd/SKILL.md)** — Turn the current conversation context into a PRD and submit it as an issue.
- **[to-issues](./skills/engineering/to-issues/SKILL.md)** — Break any plan, spec, or PRD into independently-grabbable issues using vertical slices.

### Productivity

- **[socratic](./skills/productivity/socratic/SKILL.md)** — Relentless interview about a plan or design until every branch is resolved (lean version; use `socratic-with-docs` when the project has a domain glossary).
- **[caveman](./skills/productivity/caveman/SKILL.md)** — Ultra-compressed responses. Drops filler, keeps technical substance.
- **[write-a-skill](./skills/productivity/write-a-skill/SKILL.md)** — Create new skills with proper structure, progressive disclosure, and bundled resources.

## Agents

The skills delegate phases to subagents in [`agents/`](./agents/), routed by model strength:

### Opus 4.7 — reasoning, planning, review (read-only)

- **[planner](./agents/planner.md)** — Decompose a task into ordered vertical slices with the next slice flagged. Used by `tdd`, `to-issues`, `improve-codebase-architecture`.
- **[architect](./agents/architect.md)** — Structural reasoning, deepening opportunities, ADR-grade tradeoffs. Used by `improve-codebase-architecture`, `socratic-with-docs`.
- **[diagnostician](./agents/diagnostician.md)** — 3–5 ranked, falsifiable bug hypotheses with cheapest probes. Used by `diagnose`.
- **[reviewer](./agents/reviewer.md)** — Adversarial diff review → Ship / Revise / Block. Used by `tdd`, `diagnose`, `improve-codebase-architecture`.

### Sonnet 4.6 — implementation (read-write)

- **[test-writer](./agents/test-writer.md)** — One failing test for the next slice, exercising public interfaces only. Used by `tdd`.
- **[implementer](./agents/implementer.md)** — Minimum code to turn red green, or apply a confirmed fix. Used by `tdd`, `diagnose`.
- **[refactorer](./agents/refactorer.md)** — Behaviour-preserving structural changes with the test suite as safety harness. Used by `tdd`, `improve-codebase-architecture`.
- **[instrumentor](./agents/instrumentor.md)** — Tagged `[DEBUG-xxxx]` probes / timing harnesses, one hypothesis at a time. Used by `diagnose`.

### Haiku 4.5 — structured transcription

- **[doc-writer](./agents/doc-writer.md)** — Render issues, PRDs, ADRs, CONTEXT.md updates in the project's style. Used by `to-issues`, `to-prd`, `improve-codebase-architecture`.
