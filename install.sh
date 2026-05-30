#!/usr/bin/env bash
# Install this repo's personal skills into the Claude Code and/or Copilot CLI agents.
#
# Each agent discovers skills from one global directory (~/.claude/skills,
# ~/.copilot/skills). This script treats that directory as a neutral *merge point*:
# it makes sure the directory is real, then symlinks every skill in this repo into it
# under the skill's plain name. It only ever creates or removes links that point back
# into THIS repo, so work skills wired by another repo (e.g. the dotfiles repo) are
# left untouched. The two installers never reference each other's trees.
#
# Usage:
#   ./install.sh            # install into every agent that is present
#   ./install.sh --claude   # only Claude Code  (~/.claude/skills)
#   ./install.sh --copilot  # only Copilot CLI  (~/.copilot/skills)
#
# Idempotent: re-running is a clean no-op. Override the agent home roots with
# CLAUDE_HOME / COPILOT_HOME (default ~/.claude, ~/.copilot).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
COPILOT_HOME="${COPILOT_HOME:-$HOME/.copilot}"

# ---- which agents -----------------------------------------------------------
do_claude=0
do_copilot=0
case "${1:-}" in
  --claude)  do_claude=1 ;;
  --copilot) do_copilot=1 ;;
  ""|--all)  do_claude=1; do_copilot=1 ;;
  *) echo "usage: $0 [--claude|--copilot]" >&2; exit 2 ;;
esac

# ---- discover personal skills: top-level dirs containing a SKILL.md ----------
discover_skills() {
  local d
  for d in "$REPO_ROOT"/*/; do
    [ -f "${d}SKILL.md" ] || continue
    basename "$d"
  done
}

# ---- ensure <dir> is a real directory ---------------------------------------
# A real dir is left as-is. A legacy whole-dir symlink (an agent skills dir that
# points entirely into some other repo) is "exploded" into per-entry symlinks first,
# so nothing already discoverable there is lost. A missing dir is created.
ensure_real_dir() {
  local dir="$1"
  if [ -L "$dir" ]; then
    local src entry name target
    src="$(cd "$dir" && pwd -P)"        # physical dir the legacy symlink points to
    rm "$dir"
    mkdir -p "$dir"
    for entry in "$src"/*; do
      [ -e "$entry" ] || continue
      name="$(basename "$entry")"
      target="$(cd "$entry" 2>/dev/null && pwd -P)" || target="$entry"
      ln -s "$target" "$dir/$name"
    done
    echo "migrated: $dir is now a real merge dir (preserved existing skills)"
  else
    mkdir -p "$dir"
  fi
}

# physical target of a symlink that points at a directory ("" if unresolvable)
link_dest() { cd "$1" 2>/dev/null && pwd -P; }

# ---- link one skill into a target skills dir --------------------------------
link_skill() {
  local name="$1" dir="$2"
  local src="$REPO_ROOT/$name"
  local link="$dir/$name"
  if [ -L "$link" ]; then
    local cur; cur="$(link_dest "$link" || true)"
    if [ "$cur" = "$src" ]; then echo "ok:     $name"; return; fi
    case "$cur" in
      "$REPO_ROOT"/*) rm "$link" ;;   # our own stale link (renamed/moved) — replace
      *) echo "WARN:   $link is owned by another source ($cur); skipping"; return ;;
    esac
  elif [ -e "$link" ]; then
    mv "$link" "$link.bak.$(date +%Y%m%d%H%M%S)"
    echo "backup: $link (was a real path)"
  fi
  ln -s "$src" "$link"
  echo "link:   $name -> $src"
}

# ---- remove our own stale links (skills that no longer exist) ----------------
prune() {
  local dir="$1"; shift
  local current=" $* "
  local link name cur
  for link in "$dir"/*; do
    [ -L "$link" ] || continue
    cur="$(link_dest "$link" || true)"
    case "$cur" in "$REPO_ROOT"/*) ;; *) continue ;; esac   # only our own links
    name="$(basename "$link")"
    case "$current" in
      *" $name "*) ;;                                        # still a valid skill
      *) rm "$link"; echo "prune:  $name (no matching skill in repo)" ;;
    esac
  done
}

# ---- install into one agent --------------------------------------------------
install_agent() {
  local label="$1" home="$2"
  if [ ! -d "$home" ]; then
    echo "skip $label: $home not present (agent not installed)"
    return
  fi
  local dir="$home/skills"
  ensure_real_dir "$dir"
  local skills; skills="$(discover_skills)"
  echo "== $label: $dir =="
  local name
  for name in $skills; do
    link_skill "$name" "$dir"
  done
  prune "$dir" $skills
}

if [ "$do_claude"  = 1 ]; then install_agent "Claude Code" "$CLAUDE_HOME"; fi
if [ "$do_copilot" = 1 ]; then install_agent "Copilot CLI" "$COPILOT_HOME"; fi
echo "done."
