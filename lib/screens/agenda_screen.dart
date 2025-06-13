import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/agenda_provider.dart';
import '../widgets/app_drawer.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AgendaProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Agenda')),
      drawer: const AppDrawer(),
      body: provider.eventos.isEmpty
          ? Center(
              child: ElevatedButton(
                onPressed: () => provider.carregarEventos(),
                child: const Text('Carregar Eventos'),
              ),
            )
          : ListView.builder(
              itemCount: provider.eventos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(provider.eventos[index]),
                );
              },
            ),
    );
  }
}
