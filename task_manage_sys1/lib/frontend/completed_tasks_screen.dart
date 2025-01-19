import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart'; // Import HomeScreen file to access the tasks list

class CompletedTasksScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onDeleteTask;

  const CompletedTasksScreen(
      {super.key, required this.tasks, required this.onDeleteTask});

  @override
  _CompletedTasksScreenState createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  @override
  Widget build(BuildContext context) {
    // Filter completed tasks
    List<Task> completedTasks =
        widget.tasks.where((task) => task.progress == 100).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: completedTasks.isEmpty
            ? Center(child: Text('No completed tasks'))
            : ListView.builder(
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  final task = completedTasks[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      title: Text(task.title,
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(
                        'Completed on: ${DateFormat.yMd().format(task.deadline)}',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Call onDeleteTask to delete this task
                          widget.onDeleteTask(task);
                          Navigator.of(context)
                              .pop(); // Navigate back after deleting
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
