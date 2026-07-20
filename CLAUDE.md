# CLAUDE.md

Project-specific guidance for Claude Code in this repository.

Shared development workflow: @docs/DEVELOPMENT.md

Read `AGENTS.md` before modifying tracked files. Keep this file project-specific and minimal. Do not duplicate the shared workflow here.

## Project

- Purpose: <one-sentence project description>
- Primary platform/runtime: <for example: Windows 11, WSL2 Ubuntu, Python 3.13>
- Required working directory: `<repository root or required subdirectory>`
- Compatibility requirements: <supported OS, runtime, API, database, browser, or device versions>
- In scope: <main components or work allowed in this repository>
- Out of scope: <components or behavior not included without an explicit scope change>
- Do not modify: <generated files, vendored code, protected paths, unrelated components>

## Build, test, and run

Use these commands instead of guessing alternatives. Delete lines that do not apply.

```text
<restore or bootstrap command>
<build command>
<targeted test command>
<full test command>
<lint or format verification command>
<run command>
<integration or E2E command>
```

- Required command wrapper or shell: <PowerShell, pwsh, bash, DDEV, Docker Compose, etc.>
- Required working directory: `<path>`
- Required ports/services/test data: <details>
- Warnings-as-errors, package-management, generated-code, or platform rules: <details>
- Tests that touch real files, databases, accounts, devices, networks, or paid APIs: <details>

## Environment and data safety

- `<ENV_VAR_1>` — <purpose, expected form, and what fails when absent>
- `<ENV_VAR_2>` — <purpose, expected form, and what fails when absent>
- Secrets are supplied through <secret manager or local mechanism>; never commit their values.
- Ask before installing or upgrading tools, editing global configuration, changing services, or altering the user's machine.
- Production APIs and real data: <allowed, prohibited, or approval-required behavior>
- Destructive operations: <commands and actions that always require approval>
- Test isolation: <temporary paths, disposable database, mock accounts, cleanup rules>

## Git workspace

- Base branch: `<main or master>`
- Worktree root: `<absolute path or stable sibling directory>`
- Task branch prefix: `<task, feature, fix, or other prefix>`
- Push remote: `<origin or other remote>`
- Commit messages: <for example: English, imperative mood>
- Merge policy: <for example: never merge into the base branch without explicit instruction>
- Branch cleanup policy: <when merged or abandoned branches may be deleted>

Development is serial by default. Keep the primary repository directory on the base branch and reuse an existing task branch/worktree when it already represents the same task.

## Project-specific verification

- Acceptance condition: <observable condition proving the requested behavior works>
- Real-machine/E2E procedure: `<command or concise procedure>`
- Required evidence: <logs, screenshots, database query output, generated artifact, API response>
- Do not run automatically: <production calls, destructive tests, hardware actions, paid APIs>
- Independent review required for: <authentication, migrations, deletion, concurrency, public APIs, or delete this line>
- Minimum supported environments to verify: <platform/runtime matrix>

## Repository-specific pitfalls

Only include constraints that cannot be inferred reliably from the code.

- <pitfall that has already caused a real mistake>
- <non-obvious invariant or integration constraint>
- <path, file, command, or behavior that looks safe but is not>

Delete this section when no repository-specific pitfalls exist.

## Key documents

- `DESIGN.md` — architecture, boundaries, major flows, and ADR index.
- `docs/ADR/` — accepted architecture decisions. Supersede decisions instead of silently rewriting history.
- `docs/HANDOFF.md` — current status, verification evidence, unresolved issues, and durable learning.
- `docs/research/` — dated investigations and evidence supporting decisions.
- `AGENTS.md` — short cross-agent entry point.
- `docs/DEVELOPMENT.md` — source of truth for the shared development workflow.
- `<entry-point file>` — <why this is the fastest code entry point>
