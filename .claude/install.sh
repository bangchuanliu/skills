#!/usr/bin/env bash
# Install this repo's personal skills into Claude Code only (~/.claude/skills).
# Thin wrapper around the repo-root install.sh; see that file for the full logic.
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/install.sh" --claude
