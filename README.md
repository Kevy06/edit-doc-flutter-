# Nexo Docs - Fase 1

Aplicativo Flutter Web migrado do DartPad para uma estrutura MVVM. Nesta fase, o cadastro e a autenticação são simulados e os documentos permanecem somente durante a sessão, exatamente como no código original.

## Executar o projeto

No Codespaces, pressione `F5` e escolha **Rodar App Flutter (Web Preview)**. Pelo terminal, a execução equivalente é:

```bash
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

## Relatório de Migração Arquitetural

### 1. Mapeamento de classes e widgets

| Elemento no DartPad | Localização após a migração | Responsabilidade |
|---|---|---|
| `MeuApp` e `main()` | `lib/main.dart` | Inicialização, tema e rotas nomeadas |
| `nomeDesenvolvedor` | `lib/views/home_view.dart` | Nome exibido no rodapé da Home |
| `TelaAcesso` em modo login | `lib/views/login_view.dart` | Interface e navegação da tela de login |
| `TelaAcesso` em modo cadastro | `lib/views/cadastro_view.dart` | Interface e navegação da tela de cadastro |
| `TelaHome` | `lib/views/home_view.dart` | Biblioteca, editor e comandos visuais |
| `_documentos`, `_selecionado` e `_modoLeitura` | `lib/viewmodels/documentos_viewmodel.dart` | Estado e regras dos documentos |
| `_abrir()`, `_novo()`, `_salvar()` e alternância de modo | `lib/viewmodels/documentos_viewmodel.dart` | Operações da biblioteca em memória |
| Estado de envio do login e cadastro | `lib/viewmodels/auth_viewmodel.dart` | Estado das ações de autenticação simulada |
| Documento representado apenas por `String` | `lib/models/documento.dart` | Modelo `Documento`, com o conteúdo editável |
| Dados conceituais do usuário | `lib/models/usuario.dart` | Modelo `Usuario`, preparado para nome e e-mail |
| `validarNome`, `validarEmail` e `validarSenha` | `lib/utils/validadores.dart` | Validações reutilizáveis de formulário |

Os arquivos de serviços e `editor_view.dart` foram mantidos como preparação estrutural, mas não são usados na Fase 1. Persistência, CRUD completo, tema persistente e uma tela separada de edição pertencem à Fase 2.

### 2. Alterações de estrutura e imports

O arquivo único do DartPad foi dividido por responsabilidade. Cada arquivo passou a importar somente o Material ou as classes da camada de que depende. O widget condicional `TelaAcesso(cadastro: true)` foi separado em `LoginView` e `CadastroView`, permitindo que cada rota tenha uma View própria sem duplicar regras de validação.

Os documentos, antes armazenados diretamente como `String`, passaram a usar o modelo `Documento`. Os campos internos dos ViewModels ficaram privados e são expostos por getters, evitando que as Views alterem diretamente o estado. A lista retornada pelo `DocumentosViewModel` é não modificável.

As rotas nomeadas continuam em `main.dart`: `/` para login, `/cadastro` para cadastro e `/home` para a biblioteca. Os construtores dos widgets utilizam `const` quando possível. O `TextEditingController` permanece na View por controlar diretamente um campo visual e é descartado no método `dispose()`.

### 3. Mudanças no gerenciamento de estado

Os dois usos de `setState()` existentes na Home foram removidos. As variáveis `_documentos`, `_selecionado` e `_modoLeitura` saíram de `_TelaHomeState` e foram transferidas para `DocumentosViewModel`, que estende `ChangeNotifier`.

As operações de abrir, criar, salvar e alternar o modo de leitura agora modificam o estado no ViewModel e chamam `notifyListeners()`. A `HomeView` usa `ListenableBuilder` para escutar essas notificações e reconstruir a interface. Login e cadastro também escutam o `AuthViewModel`, desabilitando o botão enquanto a ação simulada está sendo processada.

As Views mantêm apenas responsabilidades próprias da interface: `GlobalKey<FormState>`, `TextEditingController`, exibição de `SnackBar` e chamadas de navegação. As validações foram extraídas para `utils/validadores.dart`, e nenhuma View usa `setState()`.
