// Para usar kIsWeb
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/noticias_screen.dart';
import 'screens/agenda_screen.dart';
import 'screens/jogos_screen.dart';
import 'screens/mapa_screen.dart';

import 'providers/noticias_provider.dart';
import 'providers/agenda_provider.dart';
import 'providers/jogos_provider.dart';
import 'providers/mapa_provider.dart';

import 'firebase_options.dart';

// 🔔 Handler para notificações em segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("🔔 Notificação em segundo plano: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase com opções apropriadas para Web/Mobile
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configura o listener de mensagens em background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoticiasProvider()),
        ChangeNotifierProvider(create: (_) => AgendaProvider()),
        ChangeNotifierProvider(create: (_) => JogosProvider()),
        ChangeNotifierProvider(create: (_) => MapaProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// 📱 Aplicativo principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TEA Routine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/noticias': (context) => const NoticiasScreen(),
        '/agenda': (context) => const AgendaScreen(),
        '/jogos': (context) => const JogosScreen(),
        '/mapa': (context) => const MapaScreen(),
      },
    );
  }
}
