# Validação e Execução

## Requisitos Locais

- Flutter stable configurado.
- Android SDK com command line tools e licenças aceitas.
- Emulador Android ou aparelho conectado para teste manual.

O ambiente utilizado durante o desenvolvimento foi validado com Flutter `3.44.0` e Dart `3.12.0`.

## Comandos Principais

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

Para executar no dispositivo conectado:

```bash
flutter run
```

## APK Debug

Depois do build, o APK é produzido em:

```txt
build/app/outputs/flutter-apk/app-debug.apk
```

## Checklist Funcional

- Primeiro acesso mostra onboarding.
- A opção **Começar vazio** entra sem assinaturas pré-cadastradas.
- A opção **Explorar com exemplos** carrega dados demonstrativos.
- Cadastro, edição, exclusão e mudança de status funcionam.
- Busca, filtros e ordenação funcionam.
- Dashboard atualiza após alterações.
- Relatórios consideram somente assinaturas ativas.
- Configurações persistem nome e meta mensal.
- Dados permanecem após reiniciar o aplicativo.
- Ícone e splash aparecem no Android.

## Estado Validado

Na última validação local:

- `flutter analyze`: sem issues.
- `flutter test`: 20 testes passando.
- `flutter build apk --debug`: APK gerado com sucesso.

## Observação Técnica

O build atual pode emitir um aviso do plugin `shared_preferences_android` sobre uma futura migração para Built-in Kotlin. O aviso não bloqueia o build nem a execução do APK atual.
