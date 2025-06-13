import 'package:flutter/material.dart';

class MapaProvider extends ChangeNotifier {
  String _localAtual = 'Você está aqui!';

  String get localAtual => _localAtual;

  void atualizarLocal(String novoLocal) {
    _localAtual = novoLocal;
    notifyListeners();
  }
}
