import 'package:flutter/material.dart';

import 'views/cadastro_view.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexo Docs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginView(),
        '/cadastro': (_) => const CadastroView(),
        '/home': (_) => const HomeView(),
      },
    );
  }
}
