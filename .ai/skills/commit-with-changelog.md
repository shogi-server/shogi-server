---
name: commit-with-changelog
description: Write a changelog entry before committing. Use this skill whenever the user wants to commit and the project has a "changelog" file. Also use when the user says "/commit-with-changelog", "commit with changelog", "update changelog and commit", or references @changelog before committing. Drafts a changelog entry in the project's GNU-style format, shows it for approval, and writes it to the file. Does not commit automatically; waits for the user's commit command.
---

# Commit with changelog

Write a changelog entry for the current changes and get user approval.

## When to use

- The user asks to commit and the repo has a `changelog` file
- The user explicitly invokes this skill
- The user mentions updating the changelog before or during a commit

## Workflow

### Step 1: Understand the changes

Run `git diff` (staged + unstaged) and `git status` to see what changed. Read the modified files if you need more context about what the change does and why.

### Step 2: Read the existing changelog

Read the top ~20 lines of the `changelog` file to see the current date header and recent entries. This tells you:
- The author name and email format in use
- Whether to append to the existing top entry or create a new one

### Step 3: Decide: new entry or append?

One date block per pull request. Check whether the top block in the changelog
was written on the current branch (use `git log --oneline changelog` or check
the diff against the base branch).

- **Append** to the existing top block if it was created on this branch/PR.
  Add new `* [component]` items below the existing ones. Do not change the
  date or create a second block.
- **New date block** if the top entry belongs to a previous PR or the
  changelog has not been touched on this branch yet. Use today's date.
- **If unsure, ask the user.**

### Step 4: Draft the changelog entry

Write the entry matching the project's GNU-style changelog format:

```
2026-04-16  Author Name <email>

	* [component] Short description in imperative mood.
	  Extra detail if needed, with concrete numbers.
```

Rules for the text itself -- these come from the project's 20-year changelog voice:

- **Tab indent.** Every line inside an entry starts with a tab.
- **Component in brackets.** `[pairing]`, `[shogi-server]`, `[test]`, etc. Derive from the file path (e.g. `shogi_server/pairing.rb` -> `[pairing]`).
- **Imperative mood.** "Log a summary", "Fix intermittent failure", "Remove dead code". Not past tense.
- **Specific numbers over vague words.** "5040 scores on a single line" beats "many scores". "~1.7% chance per run" beats "a small chance".
- **Concise.** 1-3 lines is typical. Say what changed and why if the why isn't obvious. Don't pad.
- **No AI writing patterns.** No "enhanced", "streamlined", "comprehensive", "robust". No promotional language. No rule-of-three lists. No em-dash drama. Just say what happened. Read the existing entries -- they're plain and direct. Match that.

If you catch yourself writing something that sounds like a press release or a README badge, rewrite it shorter and flatter. The changelog is a maintenance log, not marketing copy.

### Step 5: Show the entry to the user

Present the proposed changelog text and wait for approval. The user may:
- Approve as-is
- Ask for edits
- Rewrite it themselves

Do not proceed until the user is satisfied.

### Step 6: Write the changelog

Edit the `changelog` file (append to existing entry or insert new date block at top).

**Do not commit automatically.** Even in edit mode, stop here and wait for the
user to explicitly ask you to commit. The user may want to review the full diff,
make further changes, or batch multiple edits into one commit.

## What doesn't go in the changelog

The changelog tracks application functionality changes only. Skip the changelog entry for changes to tooling, CI config, editor settings, and similar non-application files. Examples of things that do NOT need a changelog entry:

- `.claude/` (skills, settings, CLAUDE.md)
- `.github/` (workflows, PR templates)
- `Makefile`, `Dockerfile` (unless it affects how the server runs in production)
- Test-only changes (unless they fix a real bug or document new behavior)

When all changes in a commit fall into this category, just run `/commit-commands:commit` directly without touching the changelog.

## Edge cases

- If no `changelog` file exists, tell the user and fall back to `/commit-commands:commit`.
- If there are no code changes, say so. Don't fabricate a changelog entry.
- If the user already wrote the entry, skip to Step 6.
