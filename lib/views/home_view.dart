import 'package:flutter/material.dart';

import '../models/documento.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';
import '../viewmodels/tema_viewmodel.dart';
import 'editor_view.dart';

const nomeDesenvolvedor = 'Kevilyn Bitencourt';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.authViewModel,
    required this.documentosViewModel,
    required this.temaViewModel,
  });

  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;
  final TemaViewModel temaViewModel;

  Future<void> _criarDocumento(BuildContext context) async {
    late final Documento documento;
    try {
      documento = await documentosViewModel.novo();
    } catch (erro, pilha) {
      debugPrint('Falha ao criar documento: $erro\\n$pilha');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar documento: $erro')),
        );
      }
      return;
    }

    if (!context.mounted) return;
    documentosViewModel.abrir(documento.id);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EditorView(
          viewModel: documentosViewModel,
          documentoId: documento.id,
        ),
      ),
    );
  }

  Future<void> _sair(BuildContext context) async {
    await authViewModel.sair();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexo Docs'),
        actions: [
          IconButton(
            tooltip: temaViewModel.escuro
                ? 'Ativar tema claro'
                : 'Ativar tema escuro',
            icon: Icon(
              temaViewModel.escuro ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: temaViewModel.alternar,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => _sair(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListenableBuilder(
            listenable: documentosViewModel,
            builder: (context, _) {
              if (documentosViewModel.carregando) {
                return const Center(child: CircularProgressIndicator());
              }
              final documentos = documentosViewModel.documentos;
              if (documentos.isEmpty) {
                return const Center(
                  child: Text(
                    'Sua biblioteca está vazia. Crie um documento para começar.',
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Minha biblioteca',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Text('Abra um documento ou comece um novo.'),
                  const SizedBox(height: 12),
                  for (var i = 0; i < documentos.length; i++)
                    _DocumentoTile(
                      documento: documentos[i],
                      numero: i + 1,
                      selecionado:
                          documentos[i].id == documentosViewModel.selecionadoId,
                      onTap: () {
                        documentosViewModel.abrir(documentos[i].id);
                        Navigator.pushNamed(
                          context,
                          '/editor',
                          arguments: documentos[i].id,
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Desenvolvedora: $nomeDesenvolvedor',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _criarDocumento(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo documento'),
      ),
    );
  }
}

class _DocumentoTile extends StatelessWidget {
  const _DocumentoTile({
    required this.documento,
    required this.numero,
    required this.selecionado,
    required this.onTap,
  });

  final Documento documento;
  final int numero;
  final bool selecionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final titulo = documento.conteudo.trim().split('\n').first;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.description_outlined),
        title: Text(titulo.isEmpty ? 'Documento $numero' : titulo),
        subtitle: Text('Documento $numero', maxLines: 1),
        selected: selecionado,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
