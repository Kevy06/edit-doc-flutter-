# Nexo Docs — DocEditor MVVM

Aplicativo Flutter Web e Android organizado em MVVM. O projeto permite entrar/cadastrar uma conta de demonstração, alternar o tema e criar, editar, salvar e excluir documentos. Os documentos, o tema e a identificação da sessão ficam no armazenamento local do navegador/dispositivo.

## Executar

No Codespaces, pressione `F5` e escolha **Rodar App Flutter (Web Preview)**. Pelo terminal:

```bash
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

Conta demonstrativa: `prof@email.com` / `123456`. O cadastro é apenas local e em memória; contas cadastradas desaparecem ao reiniciar a aplicação. Este mecanismo é didático e não deve ser usado para contas ou senhas reais. A sessão guarda somente nome e e-mail.

## Organização MVVM

- `lib/models/`: modelos `Usuario` e `Documento`, com conversões para mapa/JSON.
- `lib/models/services/`: preferências de tema/sessão, armazenamento JSON dos documentos e autenticação local de demonstração.
- `lib/viewmodels/`: estado e operações de autenticação, documentos e tema.
- `lib/views/`: login, cadastro, biblioteca e editor.
- `lib/utils/validadores.dart`: validações reutilizáveis dos formulários.
- `lib/main.dart`: inicialização, carregamento assíncrono, tema e rotas.

## Persistência

`shared_preferences` guarda o tema, a identificação de sessão e a lista de documentos serializada em JSON. Os documentos passam por `Documento.toMap()` e `Documento.fromMap()`. Nenhuma View acessa diretamente o armazenamento.

## Validar e compilar

```bash
flutter analyze
flutter test
flutter build web --release --base-href "/edit-doc-flutter-/"
flutter build apk --release --target-platform android-arm64
```

O APK é gerado em `build/app/outputs/flutter-apk/app-release.apk`. O relatório técnico da etapa está em [`docs/relatorio_final.md`](docs/relatorio_final.md); a cópia PDF será anexada à entrega junto aos artefatos de build.

## Publicação Web

Os arquivos Web de produção já foram enviados para a branch `gh-pages`, com o caminho base `/edit-doc-flutter-/`. Para ativar a hospedagem, selecione **Settings → Pages → Deploy from a branch → gh-pages → /(root)**. Depois da ativação, o endereço esperado é <https://kevy06.github.io/edit-doc-flutter-/>.
