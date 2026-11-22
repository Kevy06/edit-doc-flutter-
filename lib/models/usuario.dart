class Usuario {
  const Usuario({required this.nome, required this.email, this.senha = ''});

  final String nome;
  final String email;
  final String senha;
}
