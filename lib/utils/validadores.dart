String? validarNome(String? value) {
  final partes = (value ?? '').trim().split(RegExp(r'\s+'));
  return partes.length < 2 ? 'Informe seu nome e sobrenome' : null;
}

String? validarEmail(String? value) {
  final email = (value ?? '').trim();
  final formato = RegExp(r'^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$');
  return formato.hasMatch(email) ? null : 'Informe um e-mail válido';
}

String? validarSenha(String? value) {
  return (value ?? '').trim().length < 6
      ? 'A senha deve ter pelo menos 6 caracteres'
      : null;
}
