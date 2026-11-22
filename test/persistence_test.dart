import 'package:edit_doc_flutter/models/services/documento_storage_service.dart';
import 'package:edit_doc_flutter/models/services/banco_local_service.dart';
import 'package:edit_doc_flutter/models/services/preferences_service.dart';
import 'package:edit_doc_flutter/viewmodels/auth_viewmodel.dart';
import 'package:edit_doc_flutter/viewmodels/documentos_viewmodel.dart';
import 'package:edit_doc_flutter/viewmodels/tema_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'documentos são serializados e recuperados após recriar o ViewModel',
    () async {
      final armazenamento = DocumentoStorageService();
      final primeiroViewModel = DocumentosViewModel(
        armazenamento: armazenamento,
      );
      await primeiroViewModel.carregar();
      final documento = await primeiroViewModel.novo();
      await primeiroViewModel.salvar(
        documento.id,
        'Conteúdo que deve persistir',
      );

      final segundoViewModel = DocumentosViewModel(
        armazenamento: armazenamento,
      );
      await segundoViewModel.carregar();

      expect(
        segundoViewModel.documentos.any(
          (item) => item.conteudo == 'Conteúdo que deve persistir',
        ),
        isTrue,
      );
      await segundoViewModel.excluir(documento.id);
      expect(
        segundoViewModel.documentos.any((item) => item.id == documento.id),
        isFalse,
      );
    },
  );

  test('preferência do tema é restaurada pelo serviço', () async {
    final preferencias = PreferencesService();
    final tema = TemaViewModel(preferencias: preferencias);
    await tema.carregar();
    expect(tema.escuro, isFalse);

    await tema.alternar();

    final temaRestaurado = TemaViewModel(preferencias: preferencias);
    await temaRestaurado.carregar();
    expect(temaRestaurado.escuro, isTrue);
  });

  test('sessão restaurada mantém apenas a identificação do usuário', () async {
    final preferencias = PreferencesService();
    final banco = BancoLocalService();
    final auth = AuthViewModel(banco: banco, preferencias: preferencias);

    expect(await auth.autenticar('prof@email.com', '123456'), isTrue);

    final authRestaurado = AuthViewModel(
      banco: banco,
      preferencias: preferencias,
    );
    await authRestaurado.restaurarSessao();
    expect(authRestaurado.usuarioAtual?.email, 'prof@email.com');
    expect(authRestaurado.usuarioAtual?.senha, isEmpty);
  });
}
