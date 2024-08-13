# Meus-Projetos
Este é um aplicativo que criei para organizar projetos de forma mais facilitada usando a metodologia Kamban
## Descrição

O **Task Manager Kanban** é um aplicativo para organização de tarefas em estilo Kanban, permitindo que usuários gerenciem seus projetos e tarefas de maneira eficiente. Este projeto foi desenvolvido utilizando Flutter e Provider para gerenciar o estado da aplicação.

## Funcionalidades

- **Gerenciamento de Projetos**: Crie, edite e exclua projetos.
- **Gerenciamento de Tarefas**: Adicione, edite, exclua e mova tarefas entre as colunas "Por Fazer", "Fazendo" e "Feito".
- **Interface Responsiva**: Layout otimizado para dispositivos móveis.
- **Ajuda Integrada**: Diálogo de ajuda na tela principal para orientar novos usuários.

## Tecnologias Utilizadas

- **Flutter**: Framework principal para desenvolvimento do aplicativo.
- **Provider**: Gerenciamento de estado.
- **uuid**: Geração de identificadores únicos para projetos e tarefas.
- **Kotlin**: Utilizado para compatibilidade com Android.

## Estrutura do Projeto

### Models

- **Project**
  - `id`: String - Identificador único do projeto.
  - `name`: String - Nome do projeto.

- **Task**
  - `id`: String - Identificador único da tarefa.
  - `name`: String - Nome da tarefa.
  - `description`: String - Descrição detalhada da tarefa.
  - `status`: Enum - Status da tarefa (todo, doing, done).

### Providers

- **ProjectProvider**
  - `projects`: Lista de projetos.
  - `getTasks(String projectId)`: Retorna as tarefas de um projeto específico.
  - Métodos para adicionar, editar e excluir projetos e tarefas.

### Screens

- **HomeScreen**
  - Tela principal que exibe a lista de projetos.
  - Diálogo para criar novos projetos.

- **ProjectScreen**
  - Exibe as tarefas de um projeto específico em colunas de Kanban.
  - Diálogo para criar, editar e excluir tarefas.

### Widgets

- **ProjectCard**
  - Componente para exibir informações básicas de um projeto na lista de projetos.
  - Permite editar e excluir projetos.

- **TaskCard**
  - Componente para exibir informações de uma tarefa dentro das colunas de Kanban.
  - Permite mover tarefas entre colunas.

## Como Executar o Projeto

1. Clone este repositório:
   
   [Meus Projetos](https://github.com/amadeuberaldin/Meus-Projetos-App.git)

3. Navegue até o diretório do projeto:

  cd task-manager-kanban

3. Instale as dependências:

  flutter pub get

4. Execute o aplicativo:

  flutter run  
