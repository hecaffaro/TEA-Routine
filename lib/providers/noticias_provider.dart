import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/noticia.dart';

class NoticiasProvider with ChangeNotifier {
  final String _apiKey = '461ecda068124ceeae1e880fee448db1';

  List<Noticia> _noticias = [];

  List<Noticia> get noticias => _noticias;

  Future<void> carregarNoticias() async {
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?q=autismo&language=pt&apiKey=$_apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        _noticias = (data['articles'] as List)
            .map((artigo) => Noticia.fromJson(artigo))
            .toList();

        notifyListeners();
      } else {
        print('❌ Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erro ao carregar notícias: $e');
    }
  }
}
