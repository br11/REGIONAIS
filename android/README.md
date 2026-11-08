# Aplicativo Android

Este diretório contém o projeto Android nativo baseado na PWA em `../pwa/`. O workspace Capacitor fica em `AgendaEnsaios/`, mantendo as dependências e os comandos separados da raiz e do projeto PWA.

## Requisitos

- Node.js 22 ou superior e npm
- Android Studio com Android SDK instalado
- JDK 21 (o JDK integrado ao Android Studio também pode ser usado)

## Preparar e abrir no Android Studio

```sh
cd android/AgendaEnsaios
npm install
npm run android
```

O comando copia os arquivos de `pwa/`, sincroniza o projeto Capacitor e abre o projeto Android no Android Studio. Configure o Android SDK e selecione um dispositivo ou emulador para compilar e executar.

## Gerar APK de depuração pelo terminal

```sh
cd android/AgendaEnsaios
npm run cap:sync
cd android
./gradlew assembleDebug
```

O APK é criado em `android/AgendaEnsaios/android/app/build/outputs/apk/debug/app-debug.apk`.

## Atualizar após alterar a PWA

Depois de modificar arquivos em `pwa/`, execute `npm run cap:sync` em `android/AgendaEnsaios` e compile novamente no Android Studio ou com `./gradlew assembleDebug`. Se o ícone da PWA mudar, execute também `npm run android:assets`.

Os arquivos da PWA não são modificados. O app carrega a interface localmente; os dados da planilha, o PDF e as bibliotecas externas ainda precisam de conexão com a internet. Atualizações para usuários com o app instalado precisam ser distribuídas em uma nova versão.

O comando `npm run android:assets` é opcional e regenera os ícones e telas de abertura a partir do ícone da PWA; requer Swift instalado.
