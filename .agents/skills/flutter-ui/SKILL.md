---
name: flutter-ui
description: Implement Flutter UI components, screens, and widgets for Assinaturas Ninja following the dark financial theme.
when_to_use: Designing screens, cards, lists, status chips, themes, layout adjustments, or translating UI_GUIDE.md into code.
---

# Assinaturas Ninja: UI Development

## 1. Referência Visual
Sempre consulte `docs/UI_GUIDE.md` antes de criar novos componentes.
- **Cores principais:** Fundo #0B1020, Cards #151B2D.
- **Destaques:** Verde (#00E676), Ciano (#00D4FF), Roxo (#8A5CFF).
- **Avisos:** Amarelo (#FFC857) para vencendo em breve, Vermelho (#FF5C7A) para vencendo hoje.

## 2. Padrões de Implementação
- **Componentização:** Não crie arquivos gigantes. Extraia `SubscriptionCard`, `SummaryCard`, `StatusChip` e `CategoryIcon` para a pasta `lib/widgets/`.
- **Tema:** Deixe o `ThemeData` no `main.dart` gerenciar estilos de texto e cores primárias para evitar hardcoding excessivo.
- **Hierarquia:** Use `Scaffold`, `AppBar` limpa, e `padding` generoso (ex: 16.0 ou 24.0 nas bordas).

## 3. Estados Vazios (Empty States)
Nunca deixe uma tela de lista vazia em branco. Siga a cópia obrigatória:
> "Nenhuma assinatura cadastrada ainda."
> "Adicione seus serviços recorrentes e descubra quanto eles pesam no mês." 
*(Inclua o botão "Adicionar assinatura" abaixo).*

## 4. Requisitos de Idioma
- Nomes de classes e variáveis: **Inglês** (ex: `buildEmptyState()`).
- Textos visíveis na tela: **Português Brasileiro** (ex: `Text('Suas assinaturas')`).