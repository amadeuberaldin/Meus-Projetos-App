import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';
import '../models/task.dart';

class ProjectProvider with ChangeNotifier {
  final List<Project> _projects = [];
  final Map<String, List<Task>> _tasks = {}; // Agora final
  final _uuid = const Uuid();

  List<Project> get projects => _projects;

  List<Task> getTasks(String projectId) => _tasks[projectId] ?? [];

  void addProject(String name) {
    final projectId = _uuid.v4();
    _projects.add(Project(id: projectId, name: name));
    _tasks[projectId] = [];
    notifyListeners();
  }

  void editProject(String id, String newName) {
    _projects.firstWhere((project) => project.id == id).name = newName;
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _tasks.remove(id);
    notifyListeners();
  }

  void addTask(String projectId, String name, String description) {
    final task = Task(
      id: _uuid.v4(),
      name: name,
      description: description,
      status: TaskStatus.todo,
    );
    _tasks[projectId]!.add(task);
    notifyListeners();
  }

  void editTask(String projectId, String taskId, String name, String description) {
    final task = _tasks[projectId]!.firstWhere((task) => task.id == taskId);
    task.name = name;
    task.description = description;
    notifyListeners();
  }

  void deleteTask(String projectId, String taskId) {
    _tasks[projectId]!.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void moveTask(String projectId, String taskId, TaskStatus newStatus) {
    final task = _tasks[projectId]!.firstWhere((task) => task.id == taskId);
    task.status = newStatus;
    notifyListeners();
  }
}
