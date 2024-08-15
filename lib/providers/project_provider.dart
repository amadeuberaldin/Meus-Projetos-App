import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';
import '../models/task.dart';

class ProjectProvider with ChangeNotifier {
  final List<Project> _projects = [];
  final Map<String, List<Task>> _tasks = {};
  final _uuid = const Uuid();

  ProjectProvider() {
    _loadData(); // Carrega os dados quando o provider é criado
  }

  List<Project> get projects => _projects;

  List<Task> getTasks(String projectId) => _tasks[projectId] ?? [];

  void addProject(String name) {
    final projectId = _uuid.v4();
    _projects.add(Project(id: projectId, name: name));
    _tasks[projectId] = [];
    _saveData();
    notifyListeners();
  }

  void editProject(String id, String newName) {
    _projects.firstWhere((project) => project.id == id).name = newName;
    _saveData();
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _tasks.remove(id);
    _saveData();
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
    _saveData();
    notifyListeners();
  }

  void editTask(String projectId, String taskId, String name, String description) {
    final task = _tasks[projectId]!.firstWhere((task) => task.id == taskId);
    task.name = name;
    task.description = description;
    _saveData();
    notifyListeners();
  }

  void deleteTask(String projectId, String taskId) {
    _tasks[projectId]!.removeWhere((task) => task.id == taskId);
    _saveData();
    notifyListeners();
  }

  void moveTask(String projectId, String taskId, TaskStatus newStatus) {
    final task = _tasks[projectId]!.firstWhere((task) => task.id == taskId);
    task.status = newStatus;
    _saveData();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Salva a lista de projetos como uma string JSON
    final projectData = _projects.map((project) => json.encode({
      'id': project.id,
      'name': project.name,
    })).toList();

    // Salva o mapa de tarefas como uma string JSON
    final taskData = _tasks.map((projectId, tasks) {
      return MapEntry(
        projectId,
        tasks.map((task) => json.encode({
          'id': task.id,
          'name': task.name,
          'description': task.description,
          'status': task.status.index, // Converte o status para um número
        })).toList(),
      );
    });

    await prefs.setStringList('projects', projectData);
    await prefs.setString('tasks', json.encode(taskData));
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final projectData = prefs.getStringList('projects') ?? [];
    final taskData = json.decode(prefs.getString('tasks') ?? '{}') as Map<String, dynamic>;

    _projects.clear();
    _tasks.clear();

    for (final projectJson in projectData) {
      final Map<String, dynamic> projectMap = json.decode(projectJson);
      final project = Project(id: projectMap['id'], name: projectMap['name']);
      _projects.add(project);
    }

    taskData.forEach((projectId, tasks) {
      final List<Task> loadedTasks = (tasks as List).map((taskJson) {
        final Map<String, dynamic> taskMap = json.decode(taskJson);
        return Task(
          id: taskMap['id'],
          name: taskMap['name'],
          description: taskMap['description'],
          status: TaskStatus.values[taskMap['status']],
        );
      }).toList();
      _tasks[projectId] = loadedTasks;
    });

    notifyListeners();
  }
}
