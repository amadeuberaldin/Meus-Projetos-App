import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../providers/project_provider.dart';
import '../screens/project_screen.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    // Obtém o status das tarefas para determinar a cor de fundo
    final tasks = Provider.of<ProjectProvider>(context).getTasks(project.id);
    final bool allTodo = tasks.every((task) => task.status == TaskStatus.todo);
    final bool allDone = tasks.every((task) => task.status == TaskStatus.done);
    final bool hasDoingOrDone = tasks.any((task) => task.status == TaskStatus.doing || task.status == TaskStatus.done);

    Color backgroundColor;
    if (allTodo) {
      backgroundColor = Colors.red.shade100; // Vermelho claro se todas as tarefas estiverem "Por Fazer"
    } else if (allDone) {
      backgroundColor = Colors.blue.shade100; // Azul claro se todas as tarefas estiverem concluídas
    } else if (hasDoingOrDone) {
      backgroundColor = Colors.yellow.shade100; // Amarelo se houver alguma tarefa em andamento ou concluída, mas ainda com tarefas "Por Fazer"
    } else {
      backgroundColor = Colors.transparent; // Sem cor caso não se encaixe em nenhuma condição
    }

    return Card(
      color: backgroundColor, // Define a cor de fundo
      child: ListTile(
        title: Text(project.name),
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
      ),
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
