import 'package:shared_preferences/shared_preferences.dart';

import '../usuario.dart';

class PreferencesService {
  static const _themeKey = 'tema_escuro';
  static const _userNameKey = 'sessao_nome';
  static const _userEmailKey = 'sessao_email';

  Future<bool> carregarTemaEscuro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> salvarTemaEscuro(bool escuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, escuro);
  }

  Future<void> salvarSessao(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, usuario.nome);
    await prefs.setString(_userEmailKey, usuario.email);
  }

  Future<Usuario?> carregarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_userEmailKey);
    final nome = prefs.getString(_userNameKey);
    if (email == null || nome == null) return null;
    return Usuario(nome: nome, email: email);
  }

  Future<void> limparSessao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }
}
