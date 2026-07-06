# CLAUDE.md

## Contexto Rápido

O **Assinaturas Ninja** é um aplicativo Flutter offline de controle financeiro de assinaturas recorrentes, desenvolvido para uma disciplina de Flutter.

O app já possui um protótipo funcional com identidade visual própria, onboarding, CRUD, dashboard, relatórios e configurações locais.

## Prioridades

1. Preservar o funcionamento do app Android.
2. Manter corretos os cálculos das assinaturas ativas.
3. Manter o onboarding sem dados automáticos para usuários novos.
4. Preservar persistência local e interface escura.
5. Evitar recursos fora do escopo acadêmico.

## Fora do Escopo

- Login ou autenticação.
- Firebase, backend ou nuvem.
- Integração bancária.
- Notificações reais.
- Pagamentos reais.
- API externa.

## Identidade e UX

- Fundo escuro elegante.
- Marca ninja verde/ciano presente no launcher, splash e interface.
- Cards arredondados e hierarquia clara.
- Destaques em verde, ciano, roxo, amarelo e vermelho conforme função.
- Interface em português brasileiro.

## Modelos

### Subscription

- `id`
- `name`
- `price`
- `dueDay`
- `category`
- `status`
- `paymentMethod`
- `notes`
- `createdAt`
- `updatedAt`

### SubscriptionStatus

- `active`: Ativa
- `paused`: Pausada
- `canceled`: Cancelada

### AppSettings

- `onboardingCompleted`
- `userName`
- `monthlyBudget`

## Regras Financeiras

- Total mensal, total anual, contagem ativa, assinatura mais cara e categorias consideram somente status `active`.
- Próxima cobrança é calculada a partir de `dueDay`.
- Vencimento próximo ocorre em até 5 dias.
- A maior assinatura ativa representa a economia mensal potencial exibida no relatório.

## Dados de Demonstração

Os exemplos existem apenas para demonstração e são carregados quando o usuário seleciona **Explorar com exemplos** no onboarding ou executa a ação correspondente em **Ajustes**:

- Netflix | 39,90 | dia 15 | Streaming | Ativa | Cartão de crédito
- Spotify | 21,90 | dia 12 | Música | Ativa | Cartão de crédito
- Game Pass | 49,99 | dia 7 | Jogos | Pausada | Cartão de crédito
- Google Drive | 9,99 | dia 20 | Nuvem | Ativa | Cartão de crédito
- Academia | 89,90 | dia 5 | Saúde | Cancelada | Pix

Nunca carregue esses exemplos automaticamente para um usuário novo.

## Fluxo Principal

1. Primeiro uso abre o onboarding.
2. Usuário escolhe começar vazio ou explorar exemplos.
3. Home mostra dashboard ou estado vazio.
4. Usuário administra assinaturas, busca, filtra e ordena.
5. Relatórios exibem panorama financeiro.
6. Ajustes permitem gerenciar preferências e dados locais.

## Validação

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

Consulte `docs/README.md` para o índice de documentação atualizado.
