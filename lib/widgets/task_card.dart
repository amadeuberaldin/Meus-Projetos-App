import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(TaskStatus) onMove;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  task.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  overflow: TextOverflow.ellipsis, // Adiciona elipses para texto muito longo
                  maxLines: 1, // Limita o texto a uma linha
                ),
              ),
              PopupMenuButton<TaskStatus>(
                icon: const Icon(Icons.more_vert),
                onSelected: (status) => onMove(status),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: TaskStatus.todo,
                    child: Text('Mover para Por Fazer'),
                  ),
                  const PopupMenuItem(
                    value: TaskStatus.doing,
                    child: Text('Mover para Fazendo'),
                  ),
                  const PopupMenuItem(
                    value: TaskStatus.done,
                    child: Text('Mover para Feito'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
