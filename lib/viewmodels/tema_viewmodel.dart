import 'package:flutter/foundation.dart';

import '../models/services/preferences_service.dart';

class TemaViewModel extends ChangeNotifier {
  TemaViewModel({PreferencesService? preferencias})
    : _preferencias = preferencias ?? PreferencesService();

  final PreferencesService _preferencias;
  bool _escuro = false;

  bool get escuro => _escuro;

  Future<void> carregar() async {
    _escuro = await _preferencias.carregarTemaEscuro();
    notifyListeners();
  }

  Future<void> alternar() async {
    _escuro = !_escuro;
    notifyListeners();
    await _preferencias.salvarTemaEscuro(_escuro);
  }
}
