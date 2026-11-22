import 'package:flutter/foundation.dart';

import '../models/services/banco_local_service.dart';
import '../models/services/preferences_service.dart';
import '../models/usuario.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({BancoLocalService? banco, PreferencesService? preferencias})
    : _banco = banco ?? BancoLocalService(),
      _preferencias = preferencias ?? PreferencesService();

  final BancoLocalService _banco;
  final PreferencesService _preferencias;
  bool _enviando = false;
  Usuario? _usuarioAtual;
  String? _erro;

  bool get enviando => _enviando;
  Usuario? get usuarioAtual => _usuarioAtual;
  String? get erro => _erro;

  Future<void> restaurarSessao() async {
    _usuarioAtual = await _preferencias.carregarSessao();
    notifyListeners();
  }

  Future<bool> autenticar(String email, String senha) async {
    _iniciarEnvio();
    try {
      final usuario = await _banco.autenticar(email.trim(), senha);
      if (usuario == null) {
        _erro = 'E-mail ou senha incorretos.';
        return false;
      }
      _usuarioAtual = usuario;
      await _preferencias.salvarSessao(usuario);
      _erro = null;
      return true;
    } finally {
      _finalizarEnvio();
    }
  }

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    _iniciarEnvio();
    try {
      final cadastrado = await _banco.cadastrarUsuario(
        Usuario(nome: nome.trim(), email: email.trim(), senha: senha),
      );
      _erro = cadastrado ? null : 'Já existe uma conta com este e-mail.';
      return cadastrado;
    } finally {
      _finalizarEnvio();
    }
  }

  Future<void> sair() async {
    _usuarioAtual = null;
    await _preferencias.limparSessao();
    notifyListeners();
  }

  void _iniciarEnvio() {
    _enviando = true;
    _erro = null;
    notifyListeners();
  }

  void _finalizarEnvio() {
    _enviando = false;
    notifyListeners();
  }
}
