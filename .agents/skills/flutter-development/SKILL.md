---
name: flutter-development
description: Build and review Assinaturas Ninja Flutter features with the repo's MVP rules, dark UI, Provider state, local persistence, and validation workflow.
when_to_use: Implementing, reviewing, or debugging Flutter code for Assinaturas Ninja, especially models, providers, screens, widgets, dashboard calculations, persistence, and form validation.
---

# Flutter Development

## Source of Truth

Read these first:

- AGENTS.md
- CLAUDE.md
- docs/PROJECT_BRIEF.md
- docs/UI_GUIDE.md
- docs/TASKS.md
- .agents/skills/flutter-development/references/project-rules.md

## Workflow

1. Confirm the nearest file, feature, or failing behavior before editing.
2. Keep the change narrow and aligned with the existing architecture.
3. Prefer simple model, service, provider, screen, widget, and utils layers.
4. Reuse the project's Portuguese UI copy and dark financial visual language.
5. Add or update validation when logic changes.

## Validation

Use the narrowest useful checks for the touched slice:

- flutter pub get
- flutter analyze
- flutter test
- flutter run when manual confirmation is needed

If a check fails, fix the touched slice first before widening scope.

## Output Expectations

- Keep the app offline.
- Do not add backend, Firebase, login, or payment flows.
- Explain what changed and why.
- Call out any remaining risks or missing follow-up work.