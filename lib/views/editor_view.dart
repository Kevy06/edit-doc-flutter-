import 'package:flutter/material.dart';

import '../viewmodels/documentos_viewmodel.dart';

class EditorView extends StatefulWidget {
  const EditorView({
    super.key,
    required this.viewModel,
    required this.documentoId,
  });

  final DocumentosViewModel viewModel;
  final String documentoId;

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  late final TextEditingController _editor;

  @override
  void initState() {
    super.initState();
    _editor = TextEditingController(
      text: widget.viewModel.documentoSelecionado?.conteudo ?? '',
    );
  }

  @override
  void dispose() {
    _editor.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    try {
      await widget.viewModel.salvar(widget.documentoId, _editor.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Documento salvo.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar o documento.')),
      );
    }
  }

  Future<void> _excluir() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir documento?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmado != true) return;
    try {
      await widget.viewModel.excluir(widget.documentoId);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível excluir o documento.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final documento = widget.viewModel.documentoSelecionado;
        if (documento == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Editor')),
            body: const Center(child: Text('Documento não encontrado.')),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Documento ${widget.viewModel.documentos.indexOf(documento) + 1}',
            ),
            actions: [
              IconButton(
                tooltip: 'Excluir documento',
                icon: const Icon(Icons.delete_outline),
                onPressed: _excluir,
              ),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _editor,
                        maxLines: null,
                        expands: true,
                        readOnly: widget.viewModel.modoLeitura,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          labelText: 'Conteúdo',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: widget.viewModel.alternarModoLeitura,
                          icon: Icon(
                            widget.viewModel.modoLeitura
                                ? Icons.edit
                                : Icons.visibility_outlined,
                          ),
                          label: Text(
                            widget.viewModel.modoLeitura
                                ? 'Modo edição'
                                : 'Modo leitura',
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: widget.viewModel.modoLeitura
                              ? null
                              : _salvar,
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Salvar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
