---
name: flutter-tests
description: Write and execute unit and widget tests for Assinaturas Ninja to ensure dashboard calculations and CRUD operations work.
when_to_use: Writing tests for providers, models, or core widgets, or debugging failing tests.
---

# Assinaturas Ninja: Testing Guidelines

Testes neste projeto não buscam 100% de coverage, mas cobertura inteligente da *Model Logic* e *Provider State*.

## 1. Unit Tests (Prioridade Alta)
Arquivos de domínio (`models/subscription.dart` e `providers/subscription_provider.dart`) detêm 90% dos riscos de erro.
**O que testar:**
- Se `isDueSoon()` retorna `true` para `dueDay` daqui a 3 dias.
- Se `isDueSoon()` retorna `false` para `dueDay` daqui a 10 dias.
- O cálculo de `totalMonthly` exclui `status == paused`?
- O cálculo de `totalMonthly` bate com a soma de 2 itens `active`?

## 2. Widget Tests (Prioridade Média)
Use para validar os **Empty States** e as renderizações condicionais:
- Verificar se "Nenhuma assinatura cadastrada ainda." aparece quando a lista for `length == 0`.
- Verificar se o componente `StatusChip` carrega a cor verde quando passado `SubscriptionStatus.active`.

## 3. Execução
Execute sempre usando a flag básica ou por tags (se implementadas):
```bash
flutter test
```