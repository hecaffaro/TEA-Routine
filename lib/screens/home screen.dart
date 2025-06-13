import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(title: 'Home'),
      drawer: const AppDrawer(),
      body: const Center(child: Text('Bem-vindo!')),
    );
  }
}
