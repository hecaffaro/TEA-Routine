import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        PopupMenuButton<String>(
          onSelected: (route) {
            Navigator.pushNamed(context, route);
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: '/noticias', child: Text('Notícias')),
            PopupMenuItem(value: '/agenda', child: Text('Agenda')),
            PopupMenuItem(value: '/jogos', child: Text('Jogos')),
            PopupMenuItem(value: '/mapa', child: Text('Mapa')),
          ],
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
