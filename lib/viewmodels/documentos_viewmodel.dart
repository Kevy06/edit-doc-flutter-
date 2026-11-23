import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/documento.dart';
import '../models/services/documento_storage_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  DocumentosViewModel({DocumentoStorageService? armazenamento})
    : _armazenamento = armazenamento ?? DocumentoStorageService();

  final DocumentoStorageService _armazenamento;
  List<Documento> _documentos = [];
  String? _selecionadoId;
  bool _modoLeitura = false;
  bool _carregando = true;
  Object? _erro;

  List<Documento> get documentos => List.unmodifiable(_documentos);
  String? get selecionadoId => _selecionadoId;
  Documento? get documentoSelecionado {
    for (final documento in _documentos) {
      if (documento.id == _selecionadoId) return documento;
    }
    return null;
  }

  bool get modoLeitura => _modoLeitura;
  bool get carregando => _carregando;
  Object? get erro => _erro;

  Future<void> carregar() async {
    _carregando = true;
    notifyListeners();
    try {
      final salvos = await _armazenamento.carregar();
      _documentos =
          salvos ??
          [
            Documento(
              id: _novoId(),
              conteudo: 'Anote aqui as ideias da próxima reunião.',
            ),
            Documento(
              id: _novoId(),
              conteudo: 'Liste aqui as etapas do seu projeto.',
            ),
          ];
      _selecionadoId = _documentos.isEmpty ? null : _documentos.first.id;
      _erro = null;
    } catch (erro) {
      _documentos = [];
      _selecionadoId = null;
      _erro = erro;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  void abrir(String id) {
    if (!_documentos.any((documento) => documento.id == id)) return;
    _selecionadoId = id;
    _modoLeitura = false;
    notifyListeners();
  }

  Future<Documento> novo() async {
    final documento = Documento(id: _novoId(), conteudo: '');
    _documentos = [..._documentos, documento];
    _selecionadoId = documento.id;
    _modoLeitura = false;
    await _persistir();
    return documento;
  }

  Future<void> salvar(String id, String conteudo) async {
    final indice = _documentos.indexWhere((documento) => documento.id == id);
    if (indice < 0) return;
    _documentos[indice].conteudo = conteudo;
    await _persistir();
  }

  Future<void> excluir(String id) async {
    _documentos = _documentos.where((documento) => documento.id != id).toList();
    if (_selecionadoId == id) {
      _selecionadoId = _documentos.isEmpty ? null : _documentos.first.id;
    }
    await _persistir();
  }

  void alternarModoLeitura() {
    _modoLeitura = !_modoLeitura;
    notifyListeners();
  }

  Future<void> _persistir() async {
    try {
      await _armazenamento.salvar(_documentos);
      _erro = null;
    } catch (erro) {
      _erro = erro;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // Use o literal: deslocamentos de 32 bits podem virar zero no JavaScript.
  String _novoId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0x100000000)}';
}
