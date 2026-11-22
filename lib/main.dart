import 'package:flutter/material.dart';

import 'models/services/banco_local_service.dart';
import 'models/services/preferences_service.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/documentos_viewmodel.dart';
import 'viewmodels/tema_viewmodel.dart';
import 'views/cadastro_view.dart';
import 'views/editor_view.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatefulWidget {
  const MeuApp({super.key});

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  late final AuthViewModel _authViewModel;
  late final DocumentosViewModel _documentosViewModel;
  late final TemaViewModel _temaViewModel;
  late final Future<void> _inicio;

  @override
  void initState() {
    super.initState();
    final preferencias = PreferencesService();
    _authViewModel = AuthViewModel(
      banco: BancoLocalService(),
      preferencias: preferencias,
    );
    _documentosViewModel = DocumentosViewModel();
    _temaViewModel = TemaViewModel(preferencias: preferencias);
    _inicio = Future.wait([
      _authViewModel.restaurarSessao(),
      _documentosViewModel.carregar(),
      _temaViewModel.carregar(),
    ]);
  }

  @override
  void dispose() {
    _authViewModel.dispose();
    _documentosViewModel.dispose();
    _temaViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _inicio,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        return ListenableBuilder(
          listenable: _temaViewModel,
          builder: (context, _) => MaterialApp(
            title: 'Nexo Docs',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: _temaViewModel.escuro ? ThemeMode.dark : ThemeMode.light,
            initialRoute: _authViewModel.usuarioAtual == null ? '/' : '/home',
            routes: {
              '/': (_) => LoginView(viewModel: _authViewModel),
              '/cadastro': (_) => CadastroView(viewModel: _authViewModel),
              '/home': (_) => HomeView(
                authViewModel: _authViewModel,
                documentosViewModel: _documentosViewModel,
                temaViewModel: _temaViewModel,
              ),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/editor') {
                return MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => EditorView(
                    viewModel: _documentosViewModel,
                    documentoId: settings.arguments as String,
                  ),
                );
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
