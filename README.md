# 📱 TEA Routine

Aplicativo Flutter desenvolvido para o projeto Smart HAS, com telas de Login, Notícias, Agenda, Jogos e Mapa integrado com Google Maps.

## ✅ Pré-requisitos

- Flutter SDK (versão 3.0 ou superior recomendada)

- Android Studio ou VS Code com plugins Flutter/Dart

- Emulador ou dispositivo físico com acesso à internet

## 🚀 Rodando o Projeto

No terminal, dentro da pasta raiz do projeto, execute:

```bash
flutter pub get
flutter run
```

## 💡 Caso esteja usando Windows:

Para evitar erros de plugins, ative o Modo Desenvolvedor:

- Pressione Win + R, digite: ms-settings:developers

- Ative o Modo Desenvolvedor

- Reinicie o computador, se necessário

## 🌐 Executar no Navegador (caso o emulador não funcione)

- No terminal, execute:
  
```bash
- flutter run -d web-server
```

- Copie o link gerado (ex: http://localhost:12345) e cole no navegador de sua preferência.

## 🔐 Permissões e APIs

- A API key do Google Maps já está configurada no código

- O app solicitará permissão de localização em tempo de execução

- O app utiliza o Firebase Cloud Messaging para notificações

## 🌍 Serviços Web Utilizados

- 🗌 Google Maps

- 🔥 Firebase

- 📰 NewsAPI (notícias sobre autismo)

## 📦 Dependências Principais

```bash
google_maps_flutter: ^2.x.x
geolocator: ^10.x.x
permission_handler: ^11.x.x
provider: ^6.x.x
http: ^1.x.x
firebase_core: ^3.x.x
firebase_messaging: ^15.x.x
```

