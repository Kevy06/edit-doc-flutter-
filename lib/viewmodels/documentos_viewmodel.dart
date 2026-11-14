import 'package:flutter/foundation.dart';

import '../models/documento.dart';

class DocumentosViewModel extends ChangeNotifier {
  final List<Documento> _documentos = [
    Documento(conteudo: 'Anote aqui as ideias da próxima reunião.'),
    Documento(conteudo: 'Liste aqui as etapas do seu projeto.'),
  ];
  int _selecionado = 0;
  bool _modoLeitura = false;

  List<Documento> get documentos => List.unmodifiable(_documentos);
  int get selecionado => _selecionado;
  bool get modoLeitura => _modoLeitura;
  String get conteudoSelecionado => _documentos[_selecionado].conteudo;

  void abrir(int indice) {
    if (indice < 0 || indice >= _documentos.length) return;
    _selecionado = indice;
    notifyListeners();
  }

  void novo() {
    _documentos.add(Documento(conteudo: ''));
    _selecionado = _documentos.length - 1;
    _modoLeitura = false;
    notifyListeners();
  }

  void salvar(String conteudo) {
    _documentos[_selecionado].conteudo = conteudo;
    notifyListeners();
  }

  void alternarModoLeitura() {
    _modoLeitura = !_modoLeitura;
    notifyListeners();
  }
}
