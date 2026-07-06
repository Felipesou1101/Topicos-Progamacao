---
name: flutter-state
description: Implement business logic, Provider management, and local data persistence for Assinaturas Ninja.
when_to_use: Creating models, providers, Hive/SharedPreferences integration, filtering logic, or calculating dashboard totals.
---

# Assinaturas Ninja: State & Persistence

## 1. Referências de Negócio
As regras de ouro estão em `CLAUDE.md` e `docs/PROJECT_BRIEF.md`.

## 2. Regras Estritas de Cálculos
Sempre implemente testes e getters no `Provider` ou na própria `Model` para:
- **Total Mensal:** `price` entra APENAS se `status == active`.
- **Mais Cara:** Busca a de maior `price` APENAS se `status == active`.
- **Próxima cobrança:** Baseado no `dueDay`. Se hoje for 12, e o `dueDay` for 15, vence neste mês. Se hoje for 16, vence no próximo.
- **Vencimento Próximo:** Retorna `true` APENAS se a próxima cobrança for em `<= 5 dias`.

## 3. Estrutura de Dados
O Model base (`Subscription`) DEVE ter, no mínimo:
`id`, `name`, `price` (> 0), `dueDay` (1 a 31), `category`, `status` (active, paused, canceled), `paymentMethod`, `notes`, `createdAt`, `updatedAt`.

## 4. Gerenciamento de Estado
- Use o pacote **Provider** (`ChangeNotifierProvider`).
- Centralize a lógica CRUD (Create, Read, Update, Delete) no seu `SubscriptionProvider`. 

## 5. Persistência
- Não use chamadas remotas. O app deve ser `offline-first`.
- Use `SharedPreferences` (json encode/decode) ou `Hive`.
- **Dados de demonstração:** Incorpore o mock do `CLAUDE.md` apenas quando o usuário solicitar exemplos no onboarding ou nos ajustes. Um usuário novo deve começar com a lista vazia.
