# Status de Implementação

## Entregue

### Fundação

- [x] Projeto Flutter Android configurado.
- [x] Dependências `provider`, `shared_preferences`, `intl` e `uuid`.
- [x] Estrutura organizada em model, provider, service, screen, widget e utils.
- [x] Tema escuro e identidade visual própria.
- [x] Persistência local e providers.

### Domínio e Persistência

- [x] `Subscription` e `SubscriptionStatus`.
- [x] Serialização local de assinaturas.
- [x] `AppSettings` e persistência das configurações.
- [x] CRUD de assinaturas.
- [x] Cálculos de dashboard, relatórios e vencimentos.
- [x] Dados demonstrativos somente mediante escolha do usuário.

### Experiência

- [x] Splash e onboarding.
- [x] Início vazio para usuário novo.
- [x] Dashboard.
- [x] Lista de assinaturas.
- [x] Cadastro, edição e detalhes.
- [x] Busca, filtros e ordenação.
- [x] Ações rápidas de status, edição e exclusão.
- [x] Relatórios por categoria e insights.
- [x] Ajustes de perfil e gerenciamento dos dados.
- [x] Ícone Android e splash com marca original.

### Qualidade

- [x] Testes unitários e de widgets.
- [x] `flutter analyze` sem issues.
- [x] Build Android debug.
- [x] Validação visual no emulador.

## Possíveis Evoluções Futuras

- [ ] Exportar resumo em arquivo local, se exigido pela disciplina.
- [ ] Testes de navegação adicionais para ações rápidas.
- [ ] Geração de APK release assinado para distribuição formal.

## Decisões de Escopo

- Sem backend, Firebase ou login.
- Sem notificações reais ou pagamentos.
- Sem inserção automática de dados de demonstração.
