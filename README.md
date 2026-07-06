# Assinaturas Ninja

Aplicativo Flutter offline para controle financeiro de assinaturas recorrentes.

## Sobre o App

O **Assinaturas Ninja** ajuda o usuário a cadastrar serviços recorrentes, acompanhar vencimentos, visualizar gastos ativos e identificar oportunidades de economia.

O primeiro acesso apresenta uma configuração inicial simples: o usuário pode começar com a lista vazia ou carregar dados de demonstração voluntariamente.

## Funcionalidades

- Boas-vindas com nome e meta mensal opcionais.
- Dashboard financeiro com próximas cobranças.
- Cadastro, edição, exclusão e detalhes de assinaturas.
- Busca, filtros, ordenação e alteração rápida de status.
- Relatórios por categoria e insights financeiros.
- Ajustes e gerenciamento local dos dados.
- Persistência offline com `SharedPreferences`.
- Tema escuro e identidade visual própria para Android.

## Tecnologias

- Flutter / Dart
- Provider
- SharedPreferences
- intl
- uuid

## Como Rodar

```bash
flutter pub get
flutter run
```

## Validação

```bash
flutter analyze
flutter test
flutter build apk --debug
```

O APK debug é gerado em:

```txt
build/app/outputs/flutter-apk/app-debug.apk
```

## Estrutura

```txt
lib/
  models/
  providers/
  screens/
  services/
  utils/
  widgets/
docs/
  README.md
  PROJECT_BRIEF.md
  UI_GUIDE.md
  ARCHITECTURE.md
  VALIDATION.md
  TASKS.md
```

## Documentação

O índice completo está em [docs/README.md](docs/README.md).

Os arquivos `AGENTS.md` e `CLAUDE.md` permanecem na raiz por fornecerem instruções operacionais para desenvolvimento assistido.

## Regras Centrais

- Apenas assinaturas ativas entram nos totais e relatórios financeiros.
- Vencimentos nos próximos 5 dias recebem destaque.
- O valor deve ser maior que zero e o dia de vencimento deve ficar entre 1 e 31.
- Dados demonstrativos nunca são inseridos automaticamente.
- O app não utiliza login, backend, Firebase ou serviços externos.
