# 📱 TEA Routine

Aplicativo Flutter desenvolvido para o projeto Smart HAS, com telas de Login, Notícias, Agenda, Jogos e Mapa integrado com Google Maps.

## ✅ Pré-requisitos

- Flutter SDK (versão 3.0 ou superior recomendada)
- Android Studio ou VS Code com plugins Flutter/Dart
- Emulador ou dispositivo físico com acesso à internet
- Backend Java com Spring Boot rodando localmente (`http://10.0.2.2:8080/api`)
- Java 17 ou superior
- Maven
- Banco de dados PostgreSQL (ou H2 para testes locais)

## 🚀 Rodando o Projeto

No terminal, para rodar o backend, execute:

```bash
cd backend
mvn spring-boot:run
```

Links do backend:

```bash
http://localhost:8080/api/noticias
http://localhost:8080/api/agenda
http://localhost:8080/api/jogos
http://localhost:8080/api/mapa
```

Senha e usuário:

```bash
admin
admin123
```

Documentação com Swagger:

```bash
http://localhost:8080/swagger-ui.html
```

No terminar, para rodar o dashboard com Angular, execute:

```bash
cd dashboard
ng serve
```

Link do dashboard:

```bash
http://localhost:4200
```

No terminal, para rodar o frontend, execute:

```bash
flutter pub get
flutter run
```

O cadastro é funcional, mas pode utilizar esta conta:

```bash
usuário@gmail.com
senha123
```

## 💡 Caso esteja usando Windows:

Para evitar erros de plugins, ative o Modo Desenvolvedor:

- Pressione Win + R, digite: ms-settings:developers

- Ative o Modo Desenvolvedor

- Reinicie o computador, se necessário

## 🌐 (IMPORTANTE) Executar por link no navegador (caso o emulador ou o projeto não funcionem corretamente)

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

- 🧠 Spring Boot (agenda e persistência de eventos)

## 📦 Dependências Principais

```bash
google_maps_flutter: ^2.x.x
geolocator: ^10.x.x
permission_handler: ^11.x.x
provider: ^6.x.x
http: ^1.x.x
firebase_core: ^3.x.x
firebase_messaging: ^15.x.x
intl: ^0.18.x
table_calendar: ^3.x.x
```

