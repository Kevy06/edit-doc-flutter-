import 'package:flutter/material.dart';

import '../viewmodels/documentos_viewmodel.dart';

const nomeDesenvolvedor = 'Kevilyn Bitencourt';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _viewModel = DocumentosViewModel();
  final _editor = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editor.text = _viewModel.conteudoSelecionado;
  }

  @override
  void dispose() {
    _editor.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _abrir(int indice) {
    _viewModel.abrir(indice);
    _editor.text = _viewModel.conteudoSelecionado;
  }

  void _novo() {
    _viewModel.novo();
    _editor.text = _viewModel.conteudoSelecionado;
  }

  void _salvar() {
    _viewModel.salvar(_editor.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Documento salvo nesta sessão.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexo Docs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Minha biblioteca',
                    style: Theme.of(context).textTheme.headlineSmall),
                const Text('Abra um documento ou comece um novo.'),
                const SizedBox(height: 12),
                for (var i = 0; i < _viewModel.documentos.length; i++)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: Text('Documento ${i + 1}'),
                      selected: i == _viewModel.selecionado,
                      onTap: () => _abrir(i),
                    ),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _editor,
                  minLines: 8,
                  maxLines: 12,
                  readOnly: _viewModel.modoLeitura,
                  decoration: InputDecoration(
                    labelText: 'Documento ${_viewModel.selecionado + 1}',
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: _novo,
                      child: const Text('Novo Documento'),
                    ),
                    FilledButton(
                      onPressed: _viewModel.modoLeitura ? null : _salvar,
                      child: const Text('Salvar'),
                    ),
                    TextButton(
                      onPressed: _viewModel.alternarModoLeitura,
                      child: Text(_viewModel.modoLeitura
                          ? 'Modo Edição'
                          : 'Modo Leitura'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        child: Center(child: Text('Desenvolvedora: $nomeDesenvolvedor')),
      ),
    );
  }
}
