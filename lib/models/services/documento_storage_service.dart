import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../documento.dart';

class DocumentoStorageService {
  static const _storageKey = 'documentos_json';

  Future<List<Documento>?> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonSalvo = prefs.getString(_storageKey);
    if (jsonSalvo == null) return null;
    final dados = jsonDecode(jsonSalvo) as List<dynamic>;
    return dados
        .map((item) => Documento.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> salvar(List<Documento> documentos) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(
      documentos.map((documento) => documento.toMap()).toList(),
    );
    await prefs.setString(_storageKey, json);
  }
}
