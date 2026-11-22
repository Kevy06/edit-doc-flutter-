# Relatório Técnico e Reflexivo — Nexo Docs

## 1. Alterações realizadas no código

Parti da versão migrada para MVVM, em que os documentos eram mantidos somente na memória e a tela Home acumulava a listagem e edição. Primeiro, ampliei o modelo `Documento` com um identificador e métodos `toMap()` e `fromMap()`. Em seguida, criei `DocumentoStorageService`, que converte a lista para JSON com `jsonEncode`, grava a string em `shared_preferences` e reconstrói os objetos com `jsonDecode` na inicialização.

O `DocumentosViewModel` passou a carregar os dados de forma assíncrona e concentrar as operações de criar, selecionar, salvar e excluir. A biblioteca abre `EditorView` para alterar cada documento. As Views chamam métodos do ViewModel, sem manipular diretamente o serviço de armazenamento.

Também implementei `PreferencesService` para salvar a escolha de tema e os dados de identificação da sessão. `TemaViewModel` controla a alternância entre tema claro e escuro. `AuthViewModel` integra as telas de login e cadastro ao serviço local de demonstração, restaura a sessão ao abrir o app e remove a sessão ao sair.

## 2. Mudanças estruturais

Antes, o estado dos documentos existia apenas enquanto o processo estava aberto. Agora, o fluxo é: View → ViewModel → Service → `shared_preferences`; na leitura, o caminho é percorrido no sentido inverso. O ViewModel notifica as Views com `notifyListeners()` e `ListenableBuilder`.

Cada `Documento` é convertido em um mapa contendo `id` e `conteudo`. `jsonEncode()` transforma a lista de mapas em uma string armazenável. No carregamento, `jsonDecode()` recria a lista e `Documento.fromMap()` converte cada mapa para o modelo. As chamadas de leitura e escrita usam `async`/`await`, e o app aguarda a restauração inicial antes de escolher a rota e o tema.

As rotas `/`, `/cadastro`, `/home` e `/editor` conectam as quatro telas. O `main.dart` instancia os ViewModels compartilhados e injeta suas dependências nas Views. O tema e a sessão são restaurados antes da exibição do fluxo principal. O logout limpa a identificação da sessão, sem remover documentos nem a preferência de tema.

## 3. Dificuldades encontradas e soluções

O primeiro teste de interface verificava o login imediatamente, mas o app ainda aguardava a leitura assíncrona de preferências. Ajustei o teste para inicializar o mock de `shared_preferences` e aguardar a conclusão da inicialização com `pumpAndSettle()`. Depois disso, os testes de interface e persistência passaram.

O comando `flutter` do ambiente local ficou aguardando no mecanismo de inicialização do SDK, sem apresentar saída. Executei o mesmo Flutter Tool diretamente pelo snapshot do SDK, o que permitiu concluir a análise estática, os testes e a compilação Web. A aplicação foi compilada para o endereço base `/edit-doc-flutter-/`, necessário ao caminho do projeto no GitHub Pages.

Para o APK, reduzi a memória do Gradle conforme o roteiro. A tentativa de compilação parou antes de iniciar o Gradle porque não há Android SDK instalado neste Windows (`No Android SDK found`). Portanto, ainda não foi possível gerar nem validar o instalador Android neste ambiente.

A versão Web compilada foi enviada para a branch `gh-pages` sem reescrever o histórico. A consulta do endpoint público de configuração do Pages retornou `404`, então a hospedagem ainda não está ativa nas configurações do repositório. A branch contém o site; é necessário habilitar **Settings → Pages → Deploy from a branch → gh-pages → /(root)** para liberar o endereço público.

O serviço de contas permanece intencionalmente em memória porque o roteiro pede persistência de tema, sessão e documentos, mas não define um backend de usuários. A conta `prof@email.com` / `123456` é de demonstração. A sessão persistida contém somente nome e e-mail; a senha não é salva. O cadastro local não sobrevive ao reinício, e essa solução não oferece segurança adequada para uso real.

## Verificações realizadas

- `flutter analyze --no-pub`: sem problemas encontrados (executado pelo Flutter Tool snapshot após o launcher local ficar aguardando no lock de inicialização).
- `flutter test --no-pub`: quatro testes aprovados, cobrindo a tela inicial, CRUD/persistência de documentos, preferência de tema e restauração da sessão.
- `flutter build web --release --base-href "/edit-doc-flutter-/"`: build concluído em `build/web`.
- APK Android: pendente; a tentativa parou porque este computador não tem Android SDK configurado.
- GitHub Pages: build compilada enviada para `gh-pages`; ativação do Pages ainda pendente nas configurações do repositório.

Este relatório descreve os resultados observados nesta execução. Antes de entregá-lo como reflexão pessoal, revisar a redação e acrescentar qualquer experiência própria que não esteja registrada aqui.
