class Task {
  final String title;
  final String description;
  final DateTime deadline;
  int progress = 0;
  final String priority; 
  final String category;
  final List<Subtask> subtasks;

  Task({
    required this.title,
    required this.description,
    required this.deadline,
    required this.subtasks,
    required this.priority,
    required this.category,
  });
}


class Subtask {
  final String title;
  bool isChecked;

  Subtask(this.title, this.isChecked);
}
