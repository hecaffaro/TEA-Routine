import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    // Escuta mensagens recebidas com o app em primeiro plano
    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title ?? 'Nova notificação';
      print('🔔 Notificação recebida: $title');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('🔔 $title')),
      );
    });
  }

  Future<void> _fazerLogin() async {
    // Solicita permissão para notificações
    final settings = await FirebaseMessaging.instance.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await FirebaseMessaging.instance.getToken();
      print('📱 Token FCM: $token');
    } else {
      print('❌ Permissão negada.');
    }

    // Navega para a próxima tela
    Navigator.pushReplacementNamed(context, '/noticias');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
  onPressed: () {
    print('✅ Botão pressionado');
    _fazerLogin();
  },
  child: const Text('Entrar'),
),

        ),
      );
  }
}
