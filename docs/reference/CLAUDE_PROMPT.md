# Prompt de Referência para Desenvolvimento

Este arquivo foi movido da raiz para `docs/reference/` porque serve como material auxiliar para iniciar uma sessão de desenvolvimento, não como documentação principal do repositório.

## Contexto

Leia primeiro:

- `AGENTS.md`
- `CLAUDE.md`
- `docs/README.md`
- `docs/PROJECT_BRIEF.md`
- `docs/ARCHITECTURE.md`
- `docs/UI_GUIDE.md`

Quando a tarefa envolver Flutter, leia também `.agents/skills/flutter-development/SKILL.md`.

## Prioridades do App

1. Manter o app executável.
2. Preservar o CRUD e os cálculos corretos.
3. Manter persistência local e fluxo de onboarding.
4. Respeitar a interface escura e a identidade visual existente.
5. Validar mudanças com análise, testes e build quando pertinente.

## Restrições

- Não use Firebase.
- Não use backend.
- Não implemente login.
- Não insira dados de exemplo automaticamente no primeiro uso.
- Não adicione recursos fora do escopo sem necessidade.

## Stack

- Flutter / Dart
- Provider
- SharedPreferences
- intl
- uuid

## Comandos

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```
