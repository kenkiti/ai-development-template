# Research

Store technical investigations, comparisons, spikes, benchmarks, and source notes that support design or implementation decisions.

## Naming

Prefer dated, descriptive filenames:

```text
YYYY-MM-DD-topic.md
```

Example:

```text
2026-07-21-worktree-strategy-comparison.md
```

## Recommended structure

```markdown
# <Topic>

## Question

## Scope

## Verified facts

## Assumptions

## Findings

## Alternatives

## Risks and unknowns

## Recommendation

## Sources and evidence
```

## Rules

- Separate verified facts from assumptions and inferences.
- Record dates and versions for time-sensitive technology.
- Prefer primary sources for technical claims.
- Include enough evidence for another person or agent to reproduce the conclusion.
- Move final architecture decisions into an ADR; do not treat research notes as accepted policy.
- Do not store secrets, credentials, personal data, or confidential production output.
