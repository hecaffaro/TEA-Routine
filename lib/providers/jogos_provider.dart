import 'package:flutter/material.dart';

class JogosProvider extends ChangeNotifier {
  List<String> _jogos = [];

  List<String> get jogos => _jogos;

  void carregarJogos() {
    _jogos = [
      'Jogo',
      'Jogo 2',
      'Jogo 3',
    ];
    notifyListeners();
  }
}
