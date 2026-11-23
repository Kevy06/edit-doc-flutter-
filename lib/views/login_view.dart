import 'package:flutter/material.dart';

import '../utils/validadores.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    final autenticado = await widget.viewModel.autenticar(
      _email.text,
      _senha.text,
    );
    if (!mounted) return;
    if (autenticado) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.viewModel.erro ?? 'Não foi possível entrar.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nexo Docs')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Acesse sua biblioteca',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Acesso de demonstração',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text('Use esta conta para avaliar o aplicativo.'),
                        const SizedBox(height: 8),
                        const Text('E-mail: prof@email.com'),
                        const Text('Senha: 123456'),
                        TextButton.icon(
                          onPressed: () {
                            _email.text = 'prof@email.com';
                            _senha.text = '123456';
                          },
                          icon: const Icon(Icons.person_outline),
                          label: const Text('Preencher dados de teste'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: validarEmail,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _senha,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: validarSenha,
                ),
                const SizedBox(height: 20),
                ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, _) => FilledButton(
                    onPressed: widget.viewModel.enviando ? null : _enviar,
                    child: const Text('Entrar'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/cadastro'),
                  child: const Text('Cadastre-se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
