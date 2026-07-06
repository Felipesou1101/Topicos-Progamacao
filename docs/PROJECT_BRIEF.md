# Project Brief: Assinaturas Ninja

## Visão Geral

**Assinaturas Ninja** é um aplicativo Flutter offline para controle de assinaturas recorrentes. Ele permite registrar serviços mensais, acompanhar vencimentos, visualizar gastos ativos e decidir onde economizar.

O projeto é voltado a uma disciplina de Flutter e deve permanecer simples de apresentar, funcional e visualmente consistente.

## Problema

Assinaturas pequenas se acumulam com facilidade. O usuário precisa enxergar quanto gasta por mês, quais cobranças se aproximam e que assinaturas poderiam ser pausadas ou canceladas.

## Solução Implementada

- Onboarding com nome e meta mensal opcionais.
- Início vazio para usuários reais e demonstração opcional.
- Dashboard com total mensal ativo, quantidade ativa, assinatura mais cara e próxima cobrança.
- CRUD completo, busca, filtros, ordenação e mudança rápida de status.
- Relatórios por categoria e insights financeiros.
- Configurações locais para perfil e gerenciamento de dados.
- Identidade visual própria e ícone Android original.

## Escopo Entregue

- Cadastrar, editar, excluir e visualizar detalhes de assinaturas.
- Ativar ou pausar uma assinatura rapidamente.
- Filtrar por todas, ativas, pausadas, canceladas e vencendo em breve.
- Buscar por nome, categoria ou forma de pagamento.
- Ordenar por vencimento, maior valor, menor valor ou nome.
- Calcular total mensal e anual apenas das assinaturas ativas.
- Exibir assinatura ativa mais cara e economia mensal potencial.
- Exibir gastos ativos por categoria e vencimentos próximos.
- Salvar assinaturas e preferências localmente.
- Limpar registros, restaurar demonstração ou refazer onboarding.

## Fora do Escopo

- Login ou autenticação.
- Backend, Firebase ou sincronização em nuvem.
- Integração bancária.
- Pagamentos reais.
- Notificações reais ou complexas.
- API externa.

## Fluxo Inicial

1. No primeiro uso, o usuário vê a tela de boas-vindas.
2. O usuário pode informar nome e meta mensal.
3. O usuário escolhe **Começar vazio** ou **Explorar com exemplos**.
4. Ao começar vazio, nenhuma assinatura é cadastrada automaticamente.
5. Os exemplos podem ser carregados posteriormente em **Ajustes**.

## Entidades

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

## Regras de Negócio

- Apenas assinaturas com status `active` entram no total mensal, total anual, contagem ativa, relatório por categoria e assinatura mais cara.
- Assinaturas pausadas e canceladas permanecem na lista, mas não entram nos totais ativos.
- Vencimento próximo significa próxima cobrança em até 5 dias.
- Vencimento no dia atual recebe destaque visual forte.
- O valor mensal deve ser maior que zero.
- O dia de vencimento deve estar entre 1 e 31.
- Dados de demonstração só podem ser inseridos por escolha explícita do usuário.

## Telas

1. `SplashScreen`: inicialização e encaminhamento.
2. `OnboardingScreen`: boas-vindas e configuração inicial.
3. `HomeScreen`: navegação inferior.
4. Dashboard: resumo financeiro e próximas cobranças.
5. `SubscriptionsScreen`: busca, ordenação, filtros e ações rápidas.
6. `SubscriptionFormScreen`: cadastro e edição.
7. `SubscriptionDetailScreen`: detalhes e comandos.
8. `ReportsScreen`: panorama anual, categorias e insights.
9. `SettingsScreen`: preferências e gerenciamento dos dados.

## Stack

- Flutter / Dart
- Provider
- SharedPreferences
- intl
- uuid

## Critérios de Aceite

- O app inicia sem crash no Android.
- O primeiro uso permite iniciar sem dados de exemplo.
- CRUD, filtros, busca, ordenação e alteração de status funcionam.
- Dashboard e relatórios calculam apenas assinaturas ativas.
- Os dados persistem localmente após reiniciar o app.
- O app permanece legível em tela de celular.
- `flutter analyze` não reporta issues.
- `flutter test` passa.
- `flutter build apk --debug` gera o APK.
