# Architecture Decision Records

Use ADRs for decisions that materially affect architecture, persistent data, public interfaces, deployment, security, dependencies, or long-term maintenance.

## Naming

```text
NNNN-short-kebab-case-title.md
```

Examples:

```text
0001-use-sqlite-for-local-state.md
0002-adopt-event-driven-notifications.md
```

## Status values

- Proposed
- Accepted
- Rejected
- Superseded
- Deprecated

## Rules

- Record the context, decision, alternatives, and consequences.
- Link supporting research from `docs/research/`.
- Do not silently rewrite an accepted decision to reflect a new choice.
- Create a new ADR and mark the old ADR as superseded.
- Keep implementation progress in `docs/HANDOFF.md`, not in ADRs.
- Keep day-to-day coding rules in `docs/DEVELOPMENT.md`, not in ADRs.

Start from [`0000-template.md`](0000-template.md).
