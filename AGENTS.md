# AGENTS.md

Cross-agent entry point for this repository. Keep this file short. The detailed workflow lives in `docs/DEVELOPMENT.md`.

## Read before changing tracked files

1. Read `CLAUDE.md` for project-specific commands, constraints, environment notes, and Git workspace values.
2. Read `docs/DEVELOPMENT.md` for the implementation, review, verification, Git, and reporting workflow.
3. Read the relevant sections of `DESIGN.md` and `docs/HANDOFF.md`.
4. Read applicable decisions in `docs/ADR/` and evidence in `docs/research/` when the task depends on them.

## Default operating contract

- Development is serial unless the user explicitly requests parallel work.
- One implementation task uses one branch, one worktree, and one Codex thread.
- Inspect existing branches and worktrees before creating anything.
- Reuse the existing branch, worktree, and Codex thread for the same task.
- A failed review does not justify creating a replacement branch, worktree, or implementation thread.
- Preserve unrelated user changes and avoid destructive Git operations.
- Continue autonomously for safe, reversible, in-scope work.
- Stop only under the escalation conditions defined in `docs/DEVELOPMENT.md`.
- Do not change the user's machine, global configuration, credentials, services, production data, or external resources without explicit approval.

## Role boundary

- **Claude Code** orchestrates repository state, worktrees, delegation, verification, documentation, commits, and pushes.
- **Codex** implements the assigned scope and performs the first review of its own final diff in the same thread.
- Codex must not create, switch, merge, rename, or delete branches or worktrees.

## Evidence rule

Claims are not evidence. Treat work as unverified until supported by the actual diff, command output, tests, or observable behavior. Clearly label anything not checked as `Unverified`.

## Completion rule

Do not report an implementation task as complete until the Definition of Done and quality gate in `docs/DEVELOPMENT.md` pass. Passing tests alone is insufficient.

## Instruction precedence

Follow explicit user instructions first, then `CLAUDE.md`, then `docs/DEVELOPMENT.md`, then this summary. When instructions conflict or no safe reversible action remains, stop the affected action and report the conflict instead of guessing.
