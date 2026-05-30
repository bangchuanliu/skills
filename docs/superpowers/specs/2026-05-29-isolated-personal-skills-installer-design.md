# Isolated Personal-Skills Installer — Design

Date: 2026-05-29
Status: Approved (brainstorming) — ready for implementation plan

## Problem

Personal skills live in this repo (`~/personal/projects/skills`): `dict`, `slack-msg`,
`domain-drill`, `local-server`, `sysdesign-drill`, `self-assessment`. Today they reach the
Claude Code and Copilot CLI agents only because a script *in the dotfiles repo*
(`banliu-dotfiles/scripts/setup-personal-skills.sh`) reaches **into** this repo and symlinks
these skills into the dotfiles skills hub (`ai-agents/skills/`), which both agents read.

This commingles two concerns in one tree and creates two owners for the same wiring. We want
**complete isolation**: the dotfiles repo owns work skills, this repo owns personal skills,
and neither references the other. This repo must be self-sufficient — clone it, run
`./install.sh`, and its skills are available to both agents.

## Obstacle

On this machine, `~/.claude/skills` and `~/.copilot/skills` are each a **whole-directory
symlink** into the dotfiles hub (`ai-agents/skills`). While the agent's entire skills dir is
a single symlink into dotfiles, anything personal added either lands *inside* the dotfiles
tree (not isolated) or is invisible to the agent. Each agent scans exactly one global skills
directory, so isolation requires turning that directory into a neutral **merge point**.

## Principle

Two repos, two independent owners, zero cross-references:

- **dotfiles** owns work skills.
- **this repo** owns personal skills.
- They meet only at a neutral *merge directory* (`~/.claude/skills`, `~/.copilot/skills`)
  that each repo populates with symlinks to **its own** skills. Neither repo's working tree
  ever contains the other's files or links.

## Architecture — merge dir of per-skill symlinks

```
~/.claude/skills/   (real dir — neutral merge point)
  ├── data-compare   -> ~/project/banliu-dotfiles/ai-agents/skills/data-compare   (dotfiles)
  ├── li-ads         -> ~/project/banliu-dotfiles/ai-agents/skills/li-ads          (dotfiles)
  ├── dict           -> ~/personal/projects/skills/dict                            (this repo)
  ├── slack-msg      -> ~/personal/projects/skills/slack-msg                       (this repo)
  └── …
~/.copilot/skills/  (same shape, same two owners)
```

Both agents discover skills by scanning their merge dir for `<name>/SKILL.md`. Per-skill
symlinks let two independent installers contribute to the same dir without either repo's tree
containing the other's content.

## Deliverables — this repo

New files:

- `install.sh` (repo root) — the real logic:
  - **Discovery:** auto-detect every top-level directory containing a `SKILL.md`. No
    hardcoded skill list, so `self-assessment` and any future skill are picked up
    automatically. (Excludes dotfiles like `docs/`, `.claude/`, `.copilot/`.)
  - **Targets:** for each agent flag passed (`--claude`, `--copilot`, or both by default),
    operate on that agent's skills dir (`~/.claude/skills`, `~/.copilot/skills`). If the
    agent's parent dir (`~/.claude` or `~/.copilot`) does not exist, skip that agent with a
    notice (agent not installed).
  - **Merge dir:** ensure the target skills dir is a real directory via `ensure_real_dir`
    (see Migration).
  - **Link:** for each discovered personal skill, idempotently create
    `<target>/<name> -> <this-repo>/<name>` under the skill's **plain** name (the SKILL.md
    `name:`, which already equals the directory name).
  - **Prune:** remove only stale symlinks in the target dir that resolve **into this repo**
    but no longer correspond to an existing skill. Never touch links that point elsewhere
    (work skills stay safe).
- `.claude/install.sh` — thin wrapper: `exec "$root/install.sh" --claude`.
- `.copilot/install.sh` — thin wrapper: `exec "$root/install.sh" --copilot`.

Notes:
- `.claude/` already exists (holds `settings.local.json`) — keep it; only add `install.sh`.
- `.copilot/` is new — create it with `install.sh`.

## Required changes — dotfiles repo

Without these, isolation does not actually hold (the dotfiles installer would clobber the
merge dir back into a whole-dir symlink, dropping personal skills on its next run):

- **Delete** `scripts/setup-personal-skills.sh`.
- **Rewrite** `.claude/install.sh` and `.copilot/install.sh`: replace the whole-dir
  `link "$SHARED/skills" "$CLAUDE/skills"` with "ensure merge dir is real, then per-work-skill
  symlink from `$SHARED/skills/*/`". Same merge-dir shape as this repo's installer.
- **Clean** `.gitignore`: remove the 5 personal-skill entries (`ai-agents/skills/_dict`,
  `_slack-msg`, `local-server`, `domain-drill`, `sysdesign-drill`).
- **Remove** the 5 stale personal symlinks now physically present in `ai-agents/skills/`
  (they are gitignored, so removal is clean) so the hub becomes pure work skills.

## One-time migration on this machine

Convert `~/.claude/skills` and `~/.copilot/skills` from "symlink → hub" into real merge dirs
**without losing work skills**, regardless of which installer runs first.

`ensure_real_dir(dir)`:
- If `dir` is a real directory → done.
- If `dir` is a symlink to a directory → "explode" it: create a real directory and recreate
  each existing entry as an individual symlink to its resolved (`realpath`) target, then swap
  the real dir into place. Work-skill links are preserved generically (no reference to the
  dotfiles repo by name).
- If `dir` is missing → `mkdir -p`.

Sequencing for the migration (interactive, one time):
1. Dotfiles cleanup first (remove the 5 stale personal symlinks from the hub + `.gitignore`),
   so the soon-to-be-exploded view is pure work skills.
2. Run dotfiles `.claude/install.sh` and `.copilot/install.sh` (updated) → merge dirs become
   real, populated with per-work-skill symlinks.
3. Run this repo's `install.sh` → adds personal-skill symlinks into the merge dirs.

On a fresh machine the explode path is never needed: the dotfiles installer creates the merge
dir as a real dir from the start, and this repo's installer adds to it.

## Idempotency & safety

- All installers are re-runnable; a second run is a clean no-op.
- Each installer manages only links that point into its own repo.
- A real (non-symlink) directory found where a skill link should go is **backed up**
  (`<name>.bak.<timestamp>`), never deleted.
- This repo's installer never modifies the dotfiles tree, and vice versa.

## Naming

Personal skills install under plain names: `dict`, `slack-msg`, `domain-drill`,
`local-server`, `sysdesign-drill`, `self-assessment`. This matches each skill's own SKILL.md
`name:`. Consequence: today's `_dict` / `_slack-msg` become `dict` / `slack-msg`. Approved.

## Verification

After running the installers:
- Each personal skill resolves to this repo in **both** agent dirs:
  `readlink ~/.claude/skills/dict` and `~/.copilot/skills/dict` point into this repo.
- All work skills still resolve into the dotfiles hub.
- `banliu-dotfiles/scripts/setup-personal-skills.sh` no longer exists.
- A second run of every installer is a clean no-op (no duplicate links, no errors).
- `self-assessment` is now installed (previously excluded).

## Out of scope

- The other dotfiles symlinks (`~/.claude/CLAUDE.md`, `agents`, `docs`,
  `~/.copilot/agents`, `copilot-instructions.md`) — shared config, not skills; unchanged.
- Packaging personal skills as a Claude/Copilot plugin or marketplace (heavier, per-agent
  divergent) — rejected in favor of the lighter merge-dir approach.
