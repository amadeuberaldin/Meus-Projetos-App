import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../widgets/project_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Usando super.key

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
                  content: const Text('Esta é a tela onde o usuário deverá criar seus projetos e organizar as tarefas necessárias para concluir o projeto.'),
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
          return ListView.builder(
            itemCount: projectProvider.projects.length + 1,
            itemBuilder: (context, index) {
              if (index == projectProvider.projects.length) {
                return ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Criar novo projeto'),
                  onTap: () {
                    _showCreateProjectDialog(context);
                  },
                );
              }
              return ProjectCard(project: projectProvider.projects[index]);
            },
          );
        },
      ),
    );
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
