# HANDOFF.md

Current execution state and durable project learning. Keep this document concise, current, deduplicated, and evidence-based.

Do not use this file as a chronological chat log. Information already obvious from code, Git history, or `DESIGN.md` does not need to be repeated.

## 1. Current status

- Current phase: <phase>
- Active task: <task or none>
- Task branch: `<branch or none>`
- Worktree: `<absolute path or none>`
- Last completed milestone: <milestone>
- Next safe action: <single concrete next action>
- Last updated: <YYYY-MM-DD>

## 2. Verification matrix

| Area / requirement | Status | Evidence | Last checked |
|---|---|---|---|
| <item> | PASS / FAIL / UNVERIFIED / NOT APPLICABLE | <command, output, screenshot, artifact, or reason> | <date> |

## 3. Known issues and technical debt

| ID | Issue | Impact | Evidence | Next action | Status |
|---|---|---|---|---|---|
| KI-001 | <issue> | <impact> | <evidence> | <action> | Open / Deferred / Resolved |

## 4. Durable facts

Facts that are verified, project-specific, not obvious from the code, and likely to matter in future sessions.

- **FACT-001** — <fact>  
  Evidence: <source, command, file, or observed behavior>  
  Verified: <YYYY-MM-DD>

## 5. Durable policies

Rules that should change future implementation or verification decisions.

- **POLICY-001** — <decision rule>  
  Reason: <why this policy exists>  
  Applies to: <scope>

## 6. Recurring bug patterns

Only record patterns observed more than once, or a single severe pattern with clear future value.

- **PATTERN-001** — <pattern>  
  Symptom: <observable failure>  
  Cause: <verified cause or clearly labeled inference>  
  Prevention: <instruction, test, or check that prevents recurrence>  
  Evidence: <issues, commits, logs, or files>  
  Last observed: <YYYY-MM-DD>

## 7. Resolved or superseded items

Keep only items whose history still explains a current constraint or prevents repeated investigation.

- <YYYY-MM-DD> — <item> — Resolved/Superseded by <decision, fix, or ADR>

## 8. Session close checklist

- [ ] Current status and next safe action are accurate.
- [ ] Verification evidence and unverified items are recorded.
- [ ] Known issues contain no duplicates.
- [ ] New durable facts are supported by evidence.
- [ ] New policies are actionable rather than descriptive.
- [ ] Recurring patterns include prevention, not only symptoms.
- [ ] False or obsolete current information was corrected.
- [ ] Routine progress noise was not added.
