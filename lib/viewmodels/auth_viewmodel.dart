import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  bool _enviando = false;

  bool get enviando => _enviando;

  Future<void> autenticar() async {
    _enviando = true;
    notifyListeners();
    await Future<void>.delayed(Duration.zero);
    _enviando = false;
    notifyListeners();
  }

  Future<void> cadastrar() => autenticar();
}
