# TEA Routine

App Flutter para o projeto Smart HAS, com telas de login, notícias, agenda, jogos e mapa integrado com Google Maps.

---

## Pré-requisitos

- Flutter SDK instalado (versão 3.0 ou superior recomendada)  
- Android Studio ou VS Code com plugins Flutter/Dart  
- Dispositivo ou emulador com acesso à internet  

---

## Rodando o projeto

No terminal, na pasta raiz do projeto, rode:

```bash
flutter pub get
flutter run
Observações importantes
A chave da API do Google Maps já está incluída no código, portanto não é necessário configurar nada adicional para o mapa funcionar.

O app solicitará permissão de localização em tempo de execução.

Se estiver usando Windows, para evitar erros de plugins, ative o Modo Desenvolvedor (Developer Mode):

Pressione Win + R e digite ms-settings:developers

Ative o modo desenvolvedor e reinicie o computador, se necessário.

Caso o emulador ou navegador não funcione corretamente faça o seguinte:

Abra o terminal e digite: flutter run -d web-server
pegue o link gerado (ex: http://localhost:12345) e cole no navegador de sua preferência.

Serviços web utilizados:

- Google maps;
- Firebase;
- NewsAPI.

Dependências principais
google_maps_flutter

geolocator

permission_handler

provider

