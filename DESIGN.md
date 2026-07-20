# DESIGN.md

Architecture and scope document for this project. Keep operational workflow rules in `docs/DEVELOPMENT.md` and current execution status in `docs/HANDOFF.md`.

## 1. Summary

<Describe the system, its users, and the problem it solves in a few paragraphs.>

## 2. Goals

- <goal>
- <goal>

## 3. Non-goals

- <explicitly excluded scope>
- <future work that must not be implemented yet>

## 4. Constraints

- <platform/runtime constraint>
- <security/privacy constraint>
- <compatibility or deployment constraint>
- <performance, cost, or operational constraint>

## 5. System context

<Describe external actors, systems, APIs, devices, storage, and trust boundaries.>

```text
<optional context diagram>
```

## 6. Architecture

### 6.1 Components

| Component | Responsibility | Interfaces | Data owned |
|---|---|---|---|
| <component> | <responsibility> | <interfaces> | <data> |

### 6.2 Main flows

#### <Flow name>

```text
<input>
→ <component>
→ <processing>
→ <output>
```

### 6.3 Data model

<Describe persistent entities, identifiers, ownership, lifecycle, migrations, and retention.>

### 6.4 Interfaces

<Describe public APIs, CLI commands, events, file formats, or UI boundaries.>

## 7. Failure handling

- <failure mode and expected behavior>
- <retry, timeout, idempotency, recovery, or fallback rule>
- <what must be observable in logs or metrics>

## 8. Security and privacy

- <authentication and authorization boundary>
- <secret handling>
- <personal/confidential data handling>
- <audit, logging, and redaction requirements>

## 9. Verification strategy

- Unit: <scope>
- Integration: <scope>
- E2E/real machine: <scope>
- Manual verification: <scope>
- Acceptance evidence: <observable evidence>

## 10. Delivery phases

| Phase | Scope | Acceptance criteria | Out of scope |
|---|---|---|---|
| Phase 0 | <technical validation> | <evidence> | <exclusions> |
| Phase 1 | <minimum usable implementation> | <evidence> | <exclusions> |

## 11. Risks and open questions

| Item | Type | Impact | Resolution owner/status |
|---|---|---|---|
| <item> | Risk / Assumption / Open question | <impact> | <status> |

## 12. ADR index

| ADR | Status | Decision |
|---|---|---|
| [ADR-0000](docs/ADR/0000-template.md) | Template | Replace with the first real decision |
