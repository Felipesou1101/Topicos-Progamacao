# Arquitetura

## Objetivo

A arquitetura do Assinaturas Ninja é intencionalmente simples: interface Flutter, estado via Provider e persistência local via SharedPreferences. Não há backend nem dependência de rede.

## Estrutura de Código

```txt
lib/
  main.dart
  models/
    app_settings.dart
    subscription.dart
  providers/
    settings_provider.dart
    subscription_provider.dart
  screens/
    home_screen.dart
    onboarding_screen.dart
    reports_screen.dart
    settings_screen.dart
    splash_screen.dart
    subscription_detail_screen.dart
    subscription_form_screen.dart
    subscriptions_screen.dart
  services/
    settings_storage.dart
    settings_storage_service.dart
    subscription_storage.dart
    subscription_storage_service.dart
  utils/
    app_colors.dart
    formatters.dart
  widgets/
    brand_mark.dart
    category_icon.dart
    empty_state.dart
    status_chip.dart
    subscription_card.dart
    summary_card.dart
```

## Responsabilidades

### Models

- `Subscription`: dados da assinatura, serialização e cálculo de próxima cobrança.
- `AppSettings`: onboarding concluído, nome e meta mensal.

### Providers

- `SubscriptionProvider`: CRUD, filtros, busca, ordenação, totais, insights e demonstração opcional.
- `SettingsProvider`: carregamento e alteração de preferências locais.

### Services

- Interfaces de storage isolam o Provider de `SharedPreferences` e facilitam testes.
- Os services concretos serializam os objetos em JSON local.

### Screens e Widgets

- Screens compõem fluxos completos de navegação.
- Widgets encapsulam componentes visuais reutilizáveis e a marca do produto.

## Fluxo de Inicialização

1. `main.dart` instancia `SubscriptionProvider` e `SettingsProvider`.
2. `SplashScreen` carrega preferências e assinaturas.
3. Se `onboardingCompleted == false`, navega para `OnboardingScreen`.
4. Caso contrário, navega para `HomeScreen`.
5. O onboarding salva configurações e escolhe entre lista vazia ou demonstração.

## Persistência

O app utiliza `SharedPreferences` com dois conjuntos de dados:

- Assinaturas serializadas em JSON.
- Configurações do app serializadas em JSON.

A persistência é local, offline e suficiente para o escopo acadêmico do MVP.

## Lógica Financeira

- O total mensal usa somente assinaturas ativas.
- O total anual é `total mensal * 12`.
- Categorias somam apenas assinaturas ativas.
- Economia potencial mensal equivale à assinatura ativa mais cara.
- A próxima cobrança é calculada com base no `dueDay` e na data atual.
- Cobrança próxima ocorre quando faltam de 0 a 5 dias.

## Testes

Os testes cobrem:

- Cálculo de vencimentos e serialização do model.
- CRUD, filtros, busca, ordenação e insights do provider.
- Configurações e onboarding.
- Componentes essenciais de estado vazio e status.
