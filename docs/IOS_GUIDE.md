# Guia de Compilação e Execução para iOS - Assinaturas Ninja

Este guia explica como compilar, executar e gerar o instalador do aplicativo **Assinaturas Ninja** para dispositivos iOS. 

Como o desenvolvimento local foi realizado em um ambiente **Windows** (onde o SDK do iOS/Xcode não está disponível), este documento apresenta as duas alternativas recomendadas:
1. **Compilação Local** (usando uma máquina macOS).
2. **Compilação na Nuvem (CI/CD)** (usando o GitHub Actions a partir do Windows).

---

## Estrutura da Plataforma iOS Configurada

A pasta `/ios` foi gerada e configurada com os seguintes metadados:
* **Nome de Exibição (Display Name):** `Assinaturas Ninja`
* **Bundle Identifier (App ID):** `br.com.assinaturasninja.assinaturas_ninja` (idêntico ao `applicationId` do Android)
* **Ícones do Aplicativo (App Icons):** Gerados a partir do `assets/branding/app_icon_master.png` em todas as resoluções necessárias para iPhone e iPad (`Assets.xcassets/AppIcon.appiconset`).

---

## Opção 1: Compilação e Execução Local (Necessário macOS)

Se você tiver acesso a um Mac (MacBook, Mac mini, iMac, etc.), siga os passos abaixo para rodar o app localmente:

### Requisitos Prévios
1. Instalar o **Xcode** (disponível na Mac App Store).
2. Instalar o **CocoaPods** (gerenciador de dependências nativas):
   ```bash
   sudo gem install cocoapods
   ```
3. Configurar as ferramentas de linha de comando do Xcode:
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

### Executando no Simulador ou Dispositivo Físico
1. Abra o terminal na pasta raiz do projeto.
2. Baixe as dependências do Flutter e do iOS:
   ```bash
   flutter pub get
   cd ios
   pod install
   cd ..
   ```
3. Inicie o simulador de iOS via Xcode ou pelo terminal:
   ```bash
   open -a Simulator
   ```
4. Execute o aplicativo:
   ```bash
   flutter run
   ```

### Gerando o Build de Produção (.ipa)
Para gerar o arquivo de instalação final para a App Store ou testes (Ad-Hoc):
```bash
flutter build ipa --release
```
O build será gerado na pasta `build/ios/archive/` e o pacote `.ipa` final em `build/ios/ipa/`.

---

## Opção 2: Compilação na Nuvem via GitHub Actions (A partir do Windows)

Você pode compilar a versão de iOS de forma totalmente gratuita utilizando a nuvem do GitHub. Isso permite que você suba o código do seu computador Windows e faça o download do arquivo de instalação do iOS compilado em um ambiente macOS virtual.

### 1. Criar o arquivo de workflow do GitHub Actions
Crie um arquivo chamado `.github/workflows/ios-build.yml` na raiz do projeto e cole o seguinte conteúdo:

```yaml
name: iOS Build

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch: # Permite rodar o build manualmente pelo painel do GitHub

jobs:
  build-ios:
    name: Build iOS IPA
    runs-on: macos-14 # Máquina virtual macOS fornecida pelo GitHub
    
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup Java (Necessário para o Flutter SDK)
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Setup Flutter SDK
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.x' # Ou 'stable'
          channel: 'stable'
          cache: true

      - name: Install Dependencies
        run: |
          flutter pub get
          
      - name: Install Pods
        run: |
          cd ios
          pod install --repo-update
          cd ..

      - name: Build IPA (No-Codesign para Testes/Acadêmico)
        run: |
          flutter build ipa --no-codesign --release

      - name: Compress Build Artifacts
        run: |
          mkdir -p build/ios/output
          mv build/ios/iphoneos/Runner.app build/ios/output/AssinaturasNinja.app
          cd build/ios/output
          zip -r ../AssinaturasNinja.zip AssinaturasNinja.app
          cd ../../..

      - name: Upload iOS App Artifact
        uses: actions/upload-artifact@v4
        with:
          name: AssinaturasNinja-iOS
          path: build/ios/AssinaturasNinja.zip
```

### 2. Como gerar e baixar o app
1. Envie o seu projeto para um repositório no **GitHub** (ex: `git push origin main`).
2. Acesse a aba **Actions** na página do seu repositório no GitHub.
3. Selecione o workflow **iOS Build** na barra lateral esquerda.
4. Clique em **Run workflow** (se estiver rodando manualmente) ou observe o build iniciar automaticamente a cada push na branch `main`.
5. Após o término do build (aproximadamente 5-8 minutos), role até o final da página e você verá a seção **Artifacts** com o link de download do `AssinaturasNinja-iOS`.

*Nota: Esse workflow compila o app sem assinatura digital (`--no-codesign`), o que é ideal para fins acadêmicos e para testar em simuladores. Para rodar em um iPhone real de terceiros, é necessário possuir uma conta de desenvolvedor da Apple vinculada.*
