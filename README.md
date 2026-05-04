# Skills

My personal collection of Claude Code skills. Adapted from [mattpocock/skills](https://github.com/mattpocock/skills), evolving into my own.

## Quickstart

```bash
npx skills@latest add leondixon/skills
```

Pick which skills (and which agents) to install. The CLI reads `.claude-plugin/plugin.json` and links the selected skills into your agent's skills directory.

After install, run `/setup-repo` once per repo to scaffold the per-project config (issue tracker, triage labels, domain doc layout) that the engineering skills consume.

## Local install

If you've cloned this repo and want to symlink every skill straight into `~/.claude/skills/`:

```bash
./scripts/link-skills.sh
```

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
