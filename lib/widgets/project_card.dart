import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';
import '../screens/project_screen.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(project.name), // O nome do projeto aparece primeiro
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditProjectDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteProjectDialog(context),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProjectScreen(project: project),
        ));
      },
    );
  }

  void _showEditProjectDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: project.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Projeto'),
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
                Provider.of<ProjectProvider>(context, listen: false).editProject(project.id, controller.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Projeto'),
        content: const Text('Você tem certeza que deseja excluir este projeto?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ProjectProvider>(context, listen: false).deleteProject(project.id);
              Navigator.of(context).pop();
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
