# Skills

My personal collection of Claude Code skills. Adapted from [mattpocock/skills](https://github.com/mattpocock/skills), evolving into my own.

## Quickstart

```bash
npx skills@latest add leondixon/skills
```

Pick which skills (and which agents) to install. The CLI reads `.claude-plugin/plugin.json` and links the selected skills into your agent's skills directory.

## Local install

If you've cloned this repo and want to symlink every skill straight into `~/.claude/skills/`:

```bash
./scripts/link-skills.sh
```

Re-run any time. Existing real directories at the target are replaced by the symlink — see the script for details.

## Skills

### Engineering

- **[tdd](./skills/engineering/tdd/SKILL.md)** — Test-driven development with red-green-refactor.

### Productivity

- **[caveman](./skills/productivity/caveman/SKILL.md)** — Ultra-compressed responses. Drops filler, keeps technical substance.
- **[socratic](./skills/productivity/socratic/SKILL.md)** — Relentless interview about a plan or design until every branch is resolved.
