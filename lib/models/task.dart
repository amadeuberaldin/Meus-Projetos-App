enum TaskStatus { todo, doing, done }

class Task {
  String id;
  String name;
  String description;
  TaskStatus status;

  Task({required this.id, required this.name, required this.description, required this.status});
}
