class Documento {
  Documento({required this.id, required this.conteudo});

  final String id;
  String conteudo;

  Map<String, dynamic> toMap() => {'id': id, 'conteudo': conteudo};

  factory Documento.fromMap(Map<String, dynamic> map) => Documento(
    id: map['id'] as String,
    conteudo: map['conteudo'] as String? ?? '',
  );
}
