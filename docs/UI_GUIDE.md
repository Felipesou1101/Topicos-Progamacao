# UI Guide: Assinaturas Ninja

## Direção Visual

O app apresenta uma identidade financeira escura, moderna e direta. A marca usa uma máscara ninja geométrica com olhos verdes sobre um bloco em degradê verde/ciano, evitando aparência infantil.

## Identidade

- Marca interna: `lib/widgets/brand_mark.dart`.
- Ícone mestre: `assets/branding/app_icon_master.png`.
- Launcher Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`.
- Splash Android: fundo escuro com a marca centralizada.

## Paleta

| Uso | Cor |
| --- | --- |
| Fundo principal | `#0B1020` |
| Fundo suave / navegação | `#10172A` |
| Cards | `#151B2D` |
| Cards secundários | `#1D263D` |
| Verde principal | `#00E676` |
| Ciano | `#00D4FF` |
| Roxo | `#8A5CFF` |
| Alerta próximo | `#FFC857` |
| Alerta hoje / exclusão | `#FF5C7A` |
| Texto secundário | `#AAB2C8` |

## Componentes

### Cards e Superfícies

- Bordas arredondadas.
- Borda sutil para separar cards do fundo.
- Sem excesso de decoração.
- Espaçamento interno confortável em celular.

### Botões

- Ação primária em verde.
- Ação secundária contornada em ciano.
- Exclusão em vermelho e sempre com confirmação.

### Status e Vencimento

- Ativa: verde.
- Pausada: amarelo.
- Cancelada: vermelho suave.
- Cobrança normal: texto secundário ou ciano.
- Vencendo em até 5 dias: amarelo.
- Vencendo hoje: vermelho.

## Experiência por Tela

### Onboarding

- Exibido enquanto a configuração inicial não foi concluída.
- Explica privacidade local, gastos e vencimentos.
- Permite nome e meta mensal opcionais.
- A ação principal é **Começar vazio**.
- A ação **Explorar com exemplos** é secundária e explícita.

### Dashboard

- Exibe marca e saudação.
- Prioriza total mensal ativo em card de alto contraste.
- Exibe ativas, mais cara e próxima cobrança.
- Mostra alerta quando há cobranças em até 5 dias.
- Em estado vazio, conserva o cabeçalho da marca e oferece cadastro.

### Assinaturas

- Campo de busca visível.
- Controle de ordenação compacto.
- Chips horizontais de filtro.
- Cards com status, valor, categoria, vencimento e menu de ações rápidas.

### Formulário

- Campos com validação clara.
- Categorias selecionadas por chips.
- Status selecionado por controle segmentado.
- Textos visíveis em português brasileiro.

### Relatórios

- Mostra gasto anual e economia mensal potencial.
- Quando existir meta, mostra consumo da meta mensal.
- Representa categorias por barras horizontais simples.
- Apresenta insights curtos e acionáveis.

### Ajustes

- Permite editar nome e meta mensal.
- Permite carregar demonstração, apagar assinaturas e refazer onboarding.
- Ações destrutivas exigem confirmação.

## Estado Vazio

- Título: **Nenhuma assinatura cadastrada ainda.**
- Apoio: **Adicione seus serviços recorrentes e descubra quanto eles pesam no mês.**
- Ação: **Adicionar assinatura**
