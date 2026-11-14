import 'package:edit_doc_flutter/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exibe a tela de login', (WidgetTester tester) async {
    await tester.pumpWidget(const MeuApp());
    expect(find.text('Acesse sua biblioteca'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Cadastre-se'), findsOneWidget);
  });
}
