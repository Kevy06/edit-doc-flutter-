import 'package:edit_doc_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('exibe a tela de login', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MeuApp());
    await tester.pumpAndSettle();
    expect(find.text('Acesse sua biblioteca'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Cadastre-se'), findsOneWidget);
  });

  testWidgets('cria documento e abre o editor', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MeuApp());
    await tester.pumpAndSettle();

    expect(find.text('E-mail: prof@email.com'), findsOneWidget);
    expect(find.text('Senha: 123456'), findsOneWidget);
    await tester.tap(find.text('Preencher dados de teste'));
    await tester.ensureVisible(find.text('Entrar'));
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Novo documento'));
    await tester.pumpAndSettle();

    expect(find.text('Salvar'), findsOneWidget);
    expect(find.text('Não foi possível criar o documento.'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.enterText(find.byType(TextFormField), 'Documento de teste web');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('Documento salvo.'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Documento de teste web'), findsOneWidget);

    // Recria a aplicação para comprovar que o documento foi persistido.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const MeuApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Documento de teste web'));
    await tester.pumpAndSettle();
    expect(find.text('Documento de teste web'), findsOneWidget);
    expect(find.text('Salvar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
