# Changelog

All notable changes to this template are documented in this file.

The format follows Keep a Changelog, and version numbers follow Semantic Versioning.

## [Unreleased]

### Added

- MIT License in `LICENSE`.
- Template update and release runbooks in `tools/UPDATE_TEMPLATE.md` and `tools/RELEASE.md`.
- PowerShell 7 project initialization helper in `tools/init-project.ps1`.

### Changed

- Clarified public-template usage and the read-only scope of the ChatGPT GitHub app in `README.md`.
- Replaced environment-specific handoff incidents with reusable placeholders in `docs/HANDOFF.md`.
- Sanitized the example local path in `tools/NEW_PROJECT.md`.
- Clarified project initialization, structure preservation, classified TBD values, and commit/push authorization rules.
- Added complete short and standard-input Codex CLI invocation examples.
- Aligned documentation language guidance with Japanese runbooks and English agent instructions.
- Added `tools/` to the README structure and responsibility map.

### Fixed

- Removed the unconditional push requirement from the new-project completion conditions.
- Prevented DESIGN and HANDOFF initialization guidance from replacing the template structure.

## [1.0.0] - 2026-07-21

### Added

- Cross-agent entry point in `AGENTS.md`.
- Project-specific Claude Code configuration in `CLAUDE.md`.
- Shared Claude Code and Codex workflow in `docs/DEVELOPMENT.md`.
- Serial one-task/one-branch/one-worktree/one-Codex-thread model.
- Codex self-review and Claude Code independent quality gate.
- Autonomous execution rules with explicit escalation conditions.
- Evidence-based progress and completion reporting.
- Definition of Done and standardized completion report.
- Durable learning structure in `docs/HANDOFF.md`.
- Architecture, ADR, and research templates.
