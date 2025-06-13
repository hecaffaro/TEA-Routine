import 'package:flutter/material.dart';

class AgendaProvider extends ChangeNotifier {
  List<String> _eventos = [];

  List<String> get eventos => _eventos;

  void carregarEventos() {
    _eventos = [
      'Terapia',
      'Tarefa',
      'Evento',
    ];
    notifyListeners();
  }
}
