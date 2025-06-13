import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jogos_provider.dart';
import '../widgets/app_drawer.dart';

class JogosScreen extends StatelessWidget {
  const JogosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JogosProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Jogos')),
      drawer: const AppDrawer(),
      body: provider.jogos.isEmpty
          ? Center(
              child: ElevatedButton(
                onPressed: () => provider.carregarJogos(),
                child: const Text('Carregar Jogos'),
              ),
            )
          : ListView.builder(
              itemCount: provider.jogos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(provider.jogos[index]),
                );
              },
            ),
    );
  }
}
