import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../providers/project_provider.dart';
import '../widgets/task_card.dart';

class ProjectScreen extends StatelessWidget {
  final Project project;

  const ProjectScreen({super.key, required this.project}); // Usando super.key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          final tasks = projectProvider.getTasks(project.id);
          final todoTasks = tasks.where((task) => task.status == TaskStatus.todo).toList();
          final doingTasks = tasks.where((task) => task.status == TaskStatus.doing).toList();
          final doneTasks = tasks.where((task) => task.status == TaskStatus.done).toList();

          return Row(
            children: [
              _buildTaskColumn(context, 'Por Fazer', todoTasks, TaskStatus.todo, project.id, projectProvider),
              _buildTaskColumn(context, 'Fazendo', doingTasks, TaskStatus.doing, project.id, projectProvider),
              _buildTaskColumn(context, 'Feito', doneTasks, TaskStatus.done, project.id, projectProvider),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskColumn(BuildContext context, String title, List<Task> tasks, TaskStatus status, String projectId, ProjectProvider projectProvider) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.transparent,
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onTap: () {
                      _showEditTaskDialog(context, task);
                    },
                    onMove: (newStatus) {
                      projectProvider.moveTask(projectId, task.id, newStatus);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Tarefa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Nome da Tarefa'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Descrição da Tarefa'),
            ),
          ],
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
              if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                Provider.of<ProjectProvider>(context, listen: false)
                    .addTask(project.id, nameController.text, descriptionController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    final TextEditingController nameController = TextEditingController(text: task.name);
    final TextEditingController descriptionController = TextEditingController(text: task.description);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Tarefa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Nome da Tarefa'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Descrição da Tarefa'),
            ),
          ],
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
              Provider.of<ProjectProvider>(context, listen: false).editTask(
                  project.id, task.id, nameController.text, descriptionController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Salvar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ProjectProvider>(context, listen: false).deleteTask(project.id, task.id);
              Navigator.of(context).pop();
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
