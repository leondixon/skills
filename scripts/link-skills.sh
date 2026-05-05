#!/usr/bin/env bash
set -euo pipefail

# Links all skills and agents in the repository into ~/.claude/, so that
# they can be used by the local Claude CLI.
#
#   skills/**/SKILL.md -> ~/.claude/skills/<name>      (symlink to skill dir)
#   agents/*.md        -> ~/.claude/agents/<name>.md   (symlink to agent file)

REPO="$(cd "$(dirname "$0")/.." && pwd)"

# --- Confirm target tool ---------------------------------------------------
# These skills/agents install into ~/.claude/, which is Claude Code's layout.
# Only Claude Code is supported; other tools have different on-disk conventions.
read -r -p "Are you installing into Claude Code? [y/N] " reply
case "$(printf '%s' "$reply" | tr '[:upper:]' '[:lower:]')" in
  y|yes) ;;
  *)
    echo "error: only Claude Code is supported. Other installations are not supported at this time." >&2
    exit 1
    ;;
esac

link_into() {
  # link_into <dest_dir> <description>
  local dest="$1"
  local label="$2"

  # If the dest is a symlink that resolves into this repo, we'd end up writing
  # symlinks back into the repo's own tree. Detect and bail.
  if [ -L "$dest" ]; then
    local resolved
    resolved="$(readlink -f "$dest")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $dest is a symlink into this repo ($resolved)." >&2
        echo "Remove it (rm \"$dest\") and re-run; the script will recreate it as a real dir." >&2
        exit 1
        ;;
    esac
  fi

  mkdir -p "$dest"
}

link_into "$HOME/.claude/skills" skills
link_into "$HOME/.claude/agents" agents

# --- Skills: each SKILL.md's directory becomes ~/.claude/skills/<dirname> ---
find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' -print0 |
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  target="$HOME/.claude/skills/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    rm -rf "$target"
  fi

  ln -sfn "$src" "$target"
  echo "linked skill   $name -> $src"
done

# --- Agents: each agents/*.md becomes ~/.claude/agents/<basename> ---
if [ -d "$REPO/agents" ]; then
  find "$REPO/agents" -maxdepth 1 -name '*.md' -print0 |
  while IFS= read -r -d '' agent_md; do
    name="$(basename "$agent_md")"
    target="$HOME/.claude/agents/$name"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      rm -rf "$target"
    fi

    ln -sfn "$agent_md" "$target"
    echo "linked agent   $name -> $agent_md"
  done
fi
