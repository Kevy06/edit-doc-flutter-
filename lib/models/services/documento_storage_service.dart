import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../documento.dart';

class DocumentoStorageService {
  static const _storageKey = 'documentos_json';
  List<Documento>? _cacheEmMemoria;
  bool _persistenciaDisponivel = true;

  bool get persistenciaDisponivel => _persistenciaDisponivel;

  Future<List<Documento>?> carregar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonSalvo = prefs.getString(_storageKey);
      if (jsonSalvo == null) return _copiar(_cacheEmMemoria);
      final dados = jsonDecode(jsonSalvo) as List<dynamic>;
      _cacheEmMemoria = dados
          .map((item) => Documento.fromMap(item as Map<String, dynamic>))
          .toList();
      _persistenciaDisponivel = true;
      return _copiar(_cacheEmMemoria);
    } catch (_) {
      _persistenciaDisponivel = false;
      return _copiar(_cacheEmMemoria);
    }
  }

  Future<void> salvar(List<Documento> documentos) async {
    _cacheEmMemoria = _copiar(documentos);
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(
        documentos.map((documento) => documento.toMap()).toList(),
      );
      _persistenciaDisponivel = await prefs.setString(_storageKey, json);
    } catch (_) {
      // Mantém a edição disponível nesta sessão mesmo se o navegador bloquear
      // o armazenamento local (por exemplo, em modo privado).
      _persistenciaDisponivel = false;
    }
  }

  List<Documento>? _copiar(List<Documento>? documentos) {
    if (documentos == null) return null;
    return documentos
        .map((documento) => Documento.fromMap(documento.toMap()))
        .toList();
  }
}
