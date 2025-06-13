import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/noticias_provider.dart';
import '../widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';


class NoticiasScreen extends StatelessWidget {
  const NoticiasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoticiasProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Notícias sobre Autismo')),
      drawer: const AppDrawer(), // ou remova se não tiver drawer
      body: provider.noticias.isEmpty
          ? Center(
              child: ElevatedButton(
                onPressed: () => provider.carregarNoticias(),
                child: const Text('Carregar Notícias'),
              ),
            )
          :ListView.builder(
  itemCount: provider.noticias.length,
  itemBuilder: (context, index) {
    final noticia = provider.noticias[index];
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () async {
          final Uri url = Uri.parse(noticia.url);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Não foi possível abrir o link')),
            );
          }
        },
        child: ListTile(
          leading: noticia.urlImagem.isNotEmpty
              ? Image.network(
                  noticia.urlImagem,
                  width: 80,
                  fit: BoxFit.cover,
                )
              : null,
          title: Text(noticia.titulo),
          subtitle: Text(noticia.descricao),
        ),
      ),
    );
  },
));

  }
}
