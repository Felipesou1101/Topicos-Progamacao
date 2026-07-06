---
name: flutter-review
description: Review Assinaturas Ninja code against the MVP constraints, ensuring no backend/Firebase and that business rules pass.
when_to_use: Before committing code, during a PR review, or when the user asks to check if the app meets the project brief.
---

# Assinaturas Ninja: Code Review & Compliance

Este Agent/Skill funciona como um "Gatekeeper" de Pull Requests/Commits, garantindo que o escopo acadêmico não foi violado.

## Step 1: Verificar Anti-Patterns (Fora de Escopo)
**FALHA AUTOMÁTICA** se o código incluir:
- SDK do Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`).
- Dependências HTTP genéricas direcionadas a APIs externas (ex:, Stripe, Pagar.me).
- Bibliotecas pesadas e desnecessárias de arquitetura (Clean Architecture exagerada para um MVP).
- Sincronização em nuvem.

## Step 2: Análise Estática
Execute o roteiro obrigatório:
```bash
flutter analyze
```
Corrija QUALQUER warning (ex: usar `const` em Widgets, nomes de variáveis fora de padrão).

## Step 3: Revisitar "Definição de Pronto"
Valide visualmente ou peça que o usuário confirme se o fluxo de QA foi feito:
1. O app abre sem crash?
2. Cadastra, edita e exclui normal?
3. O valor mensal soma apenas ativos?
4. Ao reiniciar o app, a persistência manteve as assinaturas vivas?

## Step 4: Feedback
Gere um Report Markdown na resposta com `Pass / Warning / Fail` baseado nos achados.