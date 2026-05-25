---
name: slack-msg
kind: leaf
description: Rewrite or draft concise, polite Slack messages. Use when: slack message, rewrite message, write message, draft message.
---

# Slack Message Writer

Rewrite or generate Slack messages that are polite, professional, and clear.

## Priority Order

When rules conflict, apply in this order:
1. **Polite tone** — never abrupt, never passive-aggressive
2. **Professional** — appropriate register for a work context
3. **Concise** — no filler, no redundancy
4. Everything else (formatting, structure)

## Rules

1. **Lead with the point** — ask or update first, context second
2. **Be polite, not verbose** — one "thanks" or "please" is enough, no filler
3. **Short sentences** — break compound sentences, remove qualifiers
4. **Bullet points** for 2+ items — always start at column 0, never indent
5. **No indentation** — all lines at column 0, Slack messages must be flat
6. **Slack formatting** — `*bold*`, backticks for code, `>` for quotes, `<url|text>` for links
7. **Match tone** — peers: direct; leadership: outcome-focused; cross-team: add context
8. **Clear next step** if action needed — "Could you review by Friday?" not "Let me know"
9. **Tables → code blocks** — Slack doesn't render markdown tables; use monospaced code blocks with aligned columns and emoji status icons

## Slack-Native Formatting

Bold: `*bold*` | Italic: `_italic_` | Strike: `~text~` | Code: backticks | Links: `<url|text>` | Lists: `- ` or `•` | Headings: use `*Bold text*` on own line | Tables: code blocks only

**Do NOT use**: `**bold**`, `# headings`, `[text](url)`, markdown tables with `|---|`

## Output

Always write to `/Users/banliu/personal/skills/slack-msg/messages/msg.txt` — overwrite every time, raw Slack text, no code fences. Then print the absolute file path.

Writing to a file is required because terminal indentation corrupts inline output.

## Process

1. Read user's draft or intent
2. Rewrite following rules and priority order above
3. Write to file — fully auto-pilot, no clarifying questions
