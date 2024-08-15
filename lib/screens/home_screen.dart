import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../widgets/project_card.dart';
import '../models/project.dart';
import '../models/task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Projetos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Ajuda'),
                  content: const Text(
                      'Esta é a tela onde o usuário deverá criar seus projetos e organizar as tarefas necessárias para concluir o projeto.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          final projects = projectProvider.projects;

          // Ordena os projetos com base nas cores de prioridade: Amarelo, Vermelho e Azul
          projects.sort((a, b) => _getProjectPriority(context, a).compareTo(_getProjectPriority(context, b)));

          return ListView.builder(
            itemCount: projects.length + 1,
            itemBuilder: (context, index) {
              if (index == projects.length) {
                return ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Criar novo projeto'),
                  onTap: () {
                    _showCreateProjectDialog(context);
                  },
                );
              }
              return ProjectCard(project: projects[index]);
            },
          );
        },
      ),
    );
  }

  // Função para determinar a prioridade de cor dos projetos
  int _getProjectPriority(BuildContext context, Project project) {
    final tasks = Provider.of<ProjectProvider>(context, listen: false).getTasks(project.id);
    final bool allTodo = tasks.every((task) => task.status == TaskStatus.todo);
    final bool allDone = tasks.every((task) => task.status == TaskStatus.done);
    final bool hasDoingOrDone = tasks.any((task) => task.status == TaskStatus.doing || task.status == TaskStatus.done);

    if (hasDoingOrDone) {
      return 1; // Amarelo (prioridade mais alta)
    } else if (allTodo) {
      return 2; // Vermelho (prioridade intermediária)
    } else if (allDone) {
      return 3; // Azul (prioridade mais baixa)
    }
    return 0; // Caso padrão (sem cor definida)
  }

  void _showCreateProjectDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Projeto'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nome do Projeto'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<ProjectProvider>(context, listen: false).addProject(controller.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }
}
