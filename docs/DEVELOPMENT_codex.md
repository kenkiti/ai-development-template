# DEVELOPMENT.md

Shared workflow for repositories using Codex as orchestrator and Claude Code as implementer. Project-specific commands, paths, constraints, and acceptance evidence belong in root `AGENTS.md`.

## 1. Instruction precedence

1. Explicit user instructions
2. `AGENTS.md`
3. This file
4. `CLAUDE.md`

Do not resolve conflicts by guessing, silently changing scope, or using destructive operations.

## Documentation language

- Always-loaded agent instruction files (`AGENTS.md`, `CLAUDE.md`, and `docs/DEVELOPMENT.md`) should be written primarily in English.
- Human-operated runbooks and status documents (`tools/NEW_PROJECT.md`, `tools/UPDATE_TEMPLATE.md`, `tools/RELEASE.md`, and `docs/HANDOFF.md`) may be written in Japanese.
- Shared design documents (`DESIGN.md` and `docs/ADR/`) may use the language established by the project.
- Do not translate command names or file paths. Keep status values and the main completion-report keys consistent across documents. Japanese runbooks do not need to be translated wholesale.

## 2. Operating principles

- Default to safe autonomous execution.
- Prefer evidence over confidence or narrative.
- Keep one task attached to one branch, one worktree, and one Claude Code session.
- Preserve unrelated user changes.
- Use the smallest change that fully satisfies the request.
- Treat passing tests as evidence, not as proof of complete requirement coverage.
- Record durable project knowledge, not task-by-task noise.

## 3. Roles

### 3.1 Codex

Codex owns:

- repository and worktree inspection;
- task decomposition and acceptance criteria;
- branch/worktree creation or reuse;
- Claude Code delegation and session continuity;
- inspection of the applied diff;
- build, test, lint, integration, E2E, and host-side verification, including Windows, PowerShell, GUI, and hardware checks;
- quality scoring and defect feedback;
- documentation updates;
- commit, push, merge coordination, and safe cleanup.

Codex normally delegates implementation code to Claude Code. Direct edits are limited to clearly mechanical changes with no design choice, such as formatter output, already-decided bulk renames, or trivial documentation corrections.

### 3.2 Claude Code

Claude Code owns:

- implementation within the assigned worktree and scope;
- targeted tests when available;
- inspection and correction of its own final diff;
- an evidence-based completion report.

Claude Code must not:

- create, switch, merge, rename, or delete branches or worktrees;
- edit outside the assigned worktree;
- merge into the base branch;
- change the user's machine or global configuration;
- use force push, `git reset --hard`, forced checkout, or forced worktree removal;
- hide failed checks or describe unverified behavior as complete.

### 3.3 Claude Code CLI execution contract

This section is the single source of truth for invoking Claude Code CLI. The version-specific details below are the baseline for Claude Code CLI 2.x and later compatible releases; when upgrading Claude Code CLI, verify the installed help output and update this section if the interface changes.

- `claude -p` (print mode) is non-interactive. Interactive permission prompts are not available in this mode; permission behavior must be set on the command line.
- Use `--permission-mode acceptEdits` as the standard execution mode so file edits within the worktree proceed without prompting. Do not use `--dangerously-skip-permissions`.
- Restrict tool access explicitly with `--allowedTools` when the task does not require shell access, and never grant tools beyond what the task needs.
- A standard invocation is:

  ```powershell
  Set-Location "<absolute-worktree-path>"
  claude -p `
    --permission-mode acceptEdits `
    "<implementation-prompt>"
  ```

- For a long prompt, save the prompt to a file and pass it through standard input:

  ```powershell
  Get-Content -Raw "<prompt-file>" |
    claude -p `
      --permission-mode acceptEdits
  ```

- Long prompts embedded directly in a PowerShell command are prone to quoting, newline, and special-character errors. Prefer a prompt file or standard input. The working directory must be the assigned worktree's absolute path, and Claude Code must not edit outside that worktree; do not add unrelated directories with `--add-dir`.
- For session continuity within a task, capture the session ID from the first run (`--output-format json` includes it) and continue the same session with `claude -p --resume <session-id>`. One task uses one session.
- When Claude Code CLI is upgraded, verify the actual `claude --help` output. Keep version-specific flags in this section only and do not duplicate them in other workflow sections.

- A permission or tool restriction is an implementation constraint to work through, not a reason to hand implementation back to Codex. Claude Code continues implementing within the assigned worktree and reports the exact constraint and any unverified checks.
- Codex owns host-side verification that requires the Windows machine, PowerShell, GUI, or hardware. This division does not transfer implementation ownership: Codex verifies the host result and returns concrete defects to the same Claude Code session when needed.
- Do not copy version-specific CLI flags into other workflow sections. Keep future CLI changes isolated here and prefer capability checks such as `claude --help` over assuming a particular minor-version interface.

## 4. Autonomous execution and escalation

### 4.1 Continue without asking

Continue autonomously when the action is all of the following:

- within the agreed scope;
- local to the assigned repository/worktree;
- reversible through normal editing or non-destructive Git operations;
- consistent with `AGENTS.md`, `DESIGN.md`, and accepted ADRs;
- not expected to affect production, paid services, real accounts, external users, or hardware.

Examples that normally do not require confirmation:

- reading files and inspecting repository history;
- editing in-scope tracked files;
- formatting or lint fixes;
- adding or adjusting tests;
- fixing defects introduced by the current task;
- updating relevant documentation;
- running approved local build/test commands;
- reusing the task branch, worktree, and Claude Code session;
- creating a task branch/worktree according to the configured policy;
- committing a completed phase according to project policy when the quality gate passes;
- pushing only when the specific push has already been explicitly authorized by the user.

### 4.2 Stop the affected action and escalate

Stop only when at least one of these conditions applies:

1. **Destructive or difficult-to-reverse action**  
   Deleting or overwriting important data, force operations, irreversible migrations, credential rotation, production changes, or destructive infrastructure commands.

2. **Material scope change**  
   The requested result requires changing public behavior, architecture, dependencies, persistent formats, unrelated components, or acceptance criteria beyond the agreed task.

3. **User-only decision**  
   Multiple materially different outcomes remain and no project rule, existing design, or safe default resolves the choice.

4. **Unauthorized external side effect or protected environment**  
   An action not already authorized by the user or `AGENTS.md` would affect production APIs, paid services, real accounts, emails/messages, hardware, deployment, permissions, global configuration, or the user's machine.

5. **Missing authority, secret, or required input**  
   The next meaningful action cannot be performed safely without access, approval, or information that is not present.

6. **Security, privacy, legal, or compliance concern**  
   The task may expose secrets or personal data, weaken controls, or violate an explicit policy.

Do not stop merely because a minor implementation detail is unspecified. Use the safest reversible choice consistent with existing code and document the assumption.

## 5. Standard workflow

```text
inspect repository state
→ read relevant design, handoff, ADR, and research context
→ define acceptance criteria and protected scope
→ create or reuse one task worktree
→ delegate to the existing Claude Code session
→ Claude Code implements
→ Claude Code reviews and fixes its own final diff
→ Codex independently verifies actual files and behavior
→ quality score /100
→ below 90 or critical defect: return evidence to the same Claude Code session
→ update documentation and durable learning
→ commit according to project policy
→ push only when the specific push has already been explicitly authorized by the user
→ merge only when explicitly authorized and permitted by project policy
→ retain or clean up the worktree according to project policy
```

Do not create another implementation session, branch, or worktree because review found defects. Add a separate reviewer only for high-risk work or an explicit user request.

## 6. Serial branch and worktree workflow

Default invariant:

```text
one active task = one branch = one worktree = one Claude Code session
```

Parallel implementation requires explicit user instruction. Research, planning, and diff-only review do not need a worktree unless tracked files will change.

Before creating anything:

```bash
git branch --show-current
git status --short
git branch --list
git worktree list
```

Rules:

- Preserve unrelated user changes.
- Reuse an existing worktree for the same task.
- If only the task branch exists, attach one worktree to it.
- Never create a second branch or worktree for the same task.
- Keep the primary repository directory on the base branch.
- Run implementation, verification, commits, and pushes from the task worktree.

Use values from `AGENTS.md`.

For a new task branch:

```bash
git worktree add -b <prefix>/<task-slug> <worktree-root>/<task-slug> <base-branch>
```

For an existing task branch:

```bash
git worktree add <worktree-root>/<task-slug> <prefix>/<task-slug>
```

## 7. Claude Code delegation contract

Every implementation prompt must include:

```text
Work only in: <absolute-worktree-path>
Assigned branch: <branch-name>

Do not create, switch, merge, rename, or delete branches or worktrees.
Do not edit outside the assigned worktree.
Preserve unrelated behavior and user changes.
Implement only the requested scope.

After implementation, inspect your final diff against every requirement.
Fix issues found during that review before reporting completion.
Back every completion claim with diff, test, command, or observable evidence.
Label anything not verified as Unverified.
Report changed files, requirement coverage, checks run, failed checks,
checks not run, and remaining risks.
```

Also provide:

- exact acceptance criteria;
- relevant files or copied context;
- allowed and prohibited commands;
- protected paths and external systems;
- compatibility requirements;
- known pitfalls from `AGENTS.md` and `docs/HANDOFF.md`.

Do not expect Claude Code to infer hidden constraints.

## 8. Claude Code self-review

Before reporting completion, Claude Code must:

1. inspect the final diff;
2. map every requirement to implementation or test evidence;
3. check incomplete paths, placeholders, dead code, debug output, and unconditional success results;
4. check error handling, compatibility, and unintended behavior changes;
5. run available targeted checks;
6. fix defects it finds;
7. disclose failed, skipped, and unverified checks.

Claude Code self-review is a first-pass filter. It is not final acceptance.

## 9. Evidence-based progress and reporting

### 9.1 Claims are not evidence

Before reporting progress or completion, compare each material claim with one or more of:

- actual file contents or `git diff`;
- command output and exit status;
- test output;
- logs, database queries, API responses, screenshots, or generated artifacts;
- observable behavior from the real executable or service.

Use `Unverified` for claims that have not been checked. Do not convert assumptions into facts.

### 9.2 Progress reporting

A progress report should identify:

- what is confirmed complete;
- the evidence used;
- what is currently being checked;
- blockers or unexpected results;
- what remains unverified.

Avoid percentage estimates unless they are tied to explicit acceptance items.

### 9.3 Failure reporting

When a command or test fails, report:

- the exact command;
- exit status when available;
- the relevant error output without rewriting it into a success narrative;
- the likely cause, clearly labeled as an inference when not proven;
- the next safe corrective action.

Preserve enough original output to diagnose the failure, but do not paste unrelated enormous logs.

## 10. Codex independent quality gate

Claude Code reports are claims, not evidence. Inspect the applied state directly:

```bash
git status --short
git diff --stat
git diff
```

Then run the commands in `AGENTS.md` and verify every acceptance criterion.

Score the result out of 100 using:

- requirement coverage;
- functional correctness;
- edge cases and error handling;
- tests and verification depth;
- compatibility and regression risk;
- security and data safety;
- maintainability and clarity;
- scope discipline;
- real-machine or E2E evidence.

Decision:

- **90 or higher and no critical defect:** pass.
- **Below 90 or any critical defect:** fail and return a concrete defect list to the same Claude Code session.

Each defect must state:

- observed location or behavior;
- violated requirement;
- expected result;
- correction direction;
- verification to rerun.

Re-verify every patch. Target three or fewer correction cycles, but never accept a serious defect merely to meet that target.

Independent review is appropriate for authentication, authorization, secrets, cryptography, migrations, destructive data changes, deletion/recovery, concurrency, public APIs, persistent formats, large refactors, or explicit user requests.

## 11. Verification principles

- Passing build/tests does not prove requirements are met.
- Verify each material requirement against the actual code path.
- Start the real executable or service when practical.
- Verify hooks, notifications, jobs, and writes with evidence that they fired.
- Confirm deletion or replacement claims with diff or search.
- Retain useful evidence required by `AGENTS.md`.
- Record checks not run and why.
- Do not automatically run prohibited production, destructive, paid, or hardware-affecting checks.

## 12. Definition of Done

A task is done only when all applicable conditions are true:

- requested behavior is implemented within scope;
- every acceptance criterion has evidence;
- Claude Code completed its final-diff self-review;
- Codex inspected the actual diff independently;
- required build, tests, lint, and verification pass;
- failures and skipped checks are disclosed;
- no critical defect remains;
- quality score is at least 90/100;
- no temporary debug code, unresolved placeholder, or accidental generated file remains;
- relevant documentation is updated;
- intended changes are committed according to project policy;
- push, merge, tag push, and GitHub Release actions are only performed with the required explicit authorization;
- remaining risks and unverified environments are explicit.

A task is not done merely because code was written, a build passed, or an agent said it was complete.

## 13. Commit, push, merge, and cleanup

After the quality gate passes:

1. update required documentation;
2. confirm only intended changes remain;
3. commit using the convention in `AGENTS.md`, according to project policy;
4. push only when the specific push has already been explicitly authorized by the user;
5. merge only when explicitly authorized and permitted by project policy;
6. push tags only with explicit authorization, and create a GitHub Release only when explicitly requested;
7. report branch, commit hash, push status, and verification evidence.

Commit after the quality gate passes according to project policy. Do not reuse authorization from another task or branch. Push requires authorization for that specific push.

Remove a worktree only after its branch is merged or explicitly abandoned and `git status --short` is empty. Never force-remove a dirty worktree. Branch deletion follows project policy and is separate from worktree removal.

## 14. Documentation and durable learning

### 14.1 `docs/HANDOFF.md`

Keep only information that will materially improve the next session:

- current status and next safe action;
- verification matrix, including unverified items;
- known issues and technical debt;
- durable facts that are not obvious from code;
- durable policies that should change future decisions;
- recurring bug patterns with evidence and mitigation.

Rules:

- Deduplicate before adding.
- Do not append routine progress logs or facts already obvious from code.
- Correct false information rather than preserving it as current truth.
- Preserve useful history by marking resolved or superseded items with dates when the reason still matters.
- Separate **Facts**, **Policies**, and **Bug patterns**.
- Keep entries concise and actionable.
- Read the relevant current-status, issue, and bug-pattern sections before implementation.

### 14.2 `DESIGN.md` and `docs/ADR/`

`DESIGN.md` holds architecture, boundaries, major flows, phases, and the ADR index. Store important decisions in `docs/ADR/`. Supersede accepted decisions with a new ADR instead of silently rewriting decision history.

### 14.3 `docs/research/`

Store investigations, comparisons, spikes, and source notes. Distinguish verified facts, assumptions, inferences, and open questions. Use dated filenames when useful.

### 14.4 `AGENTS.md`

Keep only project-specific commands, constraints, workspace values, verification requirements, protected paths, and pitfalls. Do not duplicate this workflow.

## 15. Environment and secret safety

Ask before:

- installing or upgrading tools;
- editing global configuration or services;
- accessing production or paid APIs;
- changing credentials, permissions, accounts, or infrastructure;
- running destructive database, filesystem, deployment, or hardware operations.

Never expose secrets in prompts, logs, commits, screenshots, fixtures, generated artifacts, or documentation.

## 16. Public snapshot from a private repository

When private history contains internal material, do not make that repository public directly.

1. Sanitize tracked content on the private side and keep tests green.
2. Export tracked files without history, for example with `git archive HEAD`.
3. Remove private-only files such as `AGENTS.md`, `docs/HANDOFF.md`, confidential research, and internal release notes as appropriate.
4. Audit the snapshot for identities, local paths, internal names, email addresses, secrets, webhook URLs, and references to excluded files.
5. Publish from a newly initialized repository with clean history.
6. Repeat export and audit for every public update and record the procedure in `docs/HANDOFF.md`.

## 17. Standard completion report

Use this structure:

```text
Summary
- <what changed and why>

Workspace
- Worktree: <absolute path>
- Branch: <branch>
- Commit: <hash or not committed>
- Push: <remote/status>

Requirement coverage
- <requirement>: <evidence>

Checks
- PASS: <command/check and evidence>
- FAIL: <command/check and relevant error>
- NOT RUN: <check and reason>

Changed areas
- <files/components>

Documentation
- <updated files or none required>

Quality gate
- Score: <n>/100
- Critical defects: <none or list>

Remaining risks
- <risk or none>

Unverified
- <item or none>

Worktree disposition
- <retained/removed and why>
```
