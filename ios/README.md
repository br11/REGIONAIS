# Aplicativo iOS

Este diretório contém o projeto nativo iOS baseado na PWA em `../pwa/`. O workspace Capacitor fica em `AgendaEnsaios/`; os comandos e dependências do app ficam isolados neste diretório.

## Requisitos

- Node.js 22 ou superior e npm
- macOS com Xcode instalado
- Uma conta Apple Developer para distribuir o aplicativo fora do simulador

## Preparar e abrir no Xcode

```sh
cd ios/AgendaEnsaios
npm install
npm run ios
```

O comando copia os arquivos de `pwa/`, sincroniza o projeto Capacitor e abre `AgendaEnsaios/ios/App/App.xcodeproj`. No Xcode, selecione uma equipe de assinatura e um dispositivo ou simulador para compilar e executar.

## Atualizar o app após alterar a PWA

Depois de modificar arquivos em `pwa/`, sincronize as alterações com o projeto iOS:

```sh
cd ios/AgendaEnsaios
npm run cap:sync
```

Em seguida, compile e execute novamente pelo Xcode. A sincronização atualiza os arquivos incluídos no app durante a próxima compilação; ela não atualiza automaticamente versões já instaladas por outras pessoas. Para distribuir as mudanças, publique uma nova versão do app, por exemplo, via TestFlight ou App Store. Atualizações sem republicar exigem configurar um sistema de *live updates* ou carregar o site hospedado remotamente; nenhuma dessas opções está configurada neste projeto.

Os arquivos da PWA não são modificados. O app carrega a interface localmente; os dados da planilha, o PDF e as bibliotecas externas ainda precisam de conexão com a internet.
