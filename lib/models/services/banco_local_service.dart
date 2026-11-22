import '../usuario.dart';

/// Autenticação didática apenas em memória; não substitui um backend seguro.
class BancoLocalService {
  final List<Usuario> _usuarios = [
    const Usuario(nome: 'Professor', email: 'prof@email.com', senha: '123456'),
  ];

  Future<bool> cadastrarUsuario(Usuario novoUsuario) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (_usuarios.any(
      (usuario) =>
          usuario.email.toLowerCase() == novoUsuario.email.toLowerCase(),
    )) {
      return false;
    }
    _usuarios.add(novoUsuario);
    return true;
  }

  Future<Usuario?> autenticar(String email, String senha) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    for (final usuario in _usuarios) {
      if (usuario.email.toLowerCase() == email.toLowerCase() &&
          usuario.senha == senha) {
        return usuario;
      }
    }
    return null;
  }
}
