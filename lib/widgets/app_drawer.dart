import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Notícias'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/noticias');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Agenda'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/agenda');
            },
          ),
          ListTile(
            leading: const Icon(Icons.sports_soccer),
            title: const Text('Jogos'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/jogos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Mapa'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/mapa');
            },
          ),
        ],
      ),
    );
  }
}
