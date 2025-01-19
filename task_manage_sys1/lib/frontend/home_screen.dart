import 'package:flutter/material.dart';
import 'package:task_manage_sys1/frontend/completed_tasks_screen.dart';
import 'package:task_manage_sys1/frontend/login_screen.dart';
import 'add_task_screen.dart';
import 'package:task_manage_sys1/models/task.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String username = 'zaid';

  // List to hold tasks
  List<Task> tasks = [
    Task(
      title: 'Meeting with client',
      description: 'Description of Task 1',
      deadline: DateTime.now().add(Duration(days: 5)),
      subtasks: [
        Subtask('Negoiations', false),
        Subtask('close the deal', false),
      ],
      priority: "Low",
      category: "Meeting",
    ),
    Task(
      title: 'Update the repo',
      description: 'Description of Task 2',
      deadline: DateTime.now().add(Duration(days: 10)),
      subtasks: [
        Subtask('Subtask 2.1', false),
        Subtask('Subtask 2.2', false),
      ],
      priority: "High",
      category: "Projects",
    ),
  ];
Future<void> _signOut(BuildContext context) async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      
      // Navigate back to LoginScreen after sign out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      // Handle any sign-out errors here if necessary
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }
  // Function to add a task to the list
  void _addNewTask(Task task) {
    setState(() {
      tasks.add(task); // Add the task to the list
    });
  }

  // Function to display task details
  void _showTaskDetails(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(task.title),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deadline: ${DateFormat.yMd().format(task.deadline)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Description: ${task.description}',
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Subtasks:',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: task.subtasks.map((subtask) {
                        return CheckboxListTile(
                          title: Text(subtask.title),
                          value: subtask.isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              subtask.isChecked = value!;
                              _updateTaskProgress(task);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 15),
                    LinearProgressIndicator(
                      value: task.progress / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation(Colors.green),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Progress: ${task.progress}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Priority: ${task.priority}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: task.priority == 'High'
                            ? Colors.red
                            : task.priority == 'Medium'
                                ? Colors.orange
                                : Colors.green, // Color-coded priority
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Category: ${task.category}',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Function to update task progress
  void _updateTaskProgress(Task task) {
    final completedSubtasks =
        task.subtasks.where((subtask) => subtask.isChecked).length;
    final progress = ((completedSubtasks / task.subtasks.length) * 100).round();

    setState(() {
      task.progress = progress;
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      tasks.remove(task); // Removes the task from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    // Group tasks by priority
    List<Task> highPriorityTasks =
        tasks.where((task) => task.priority == 'High').toList();
    List<Task> mediumPriorityTasks =
        tasks.where((task) => task.priority == 'Medium').toList();
    List<Task> lowPriorityTasks =
        tasks.where((task) => task.priority == 'Low').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        actions: [
          Text(
            "Completed Tasks",
            style: TextStyle(color: Color.fromARGB(246, 1, 254, 1)),
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompletedTasksScreen(
                    tasks: tasks, // Pass tasks to CompletedTasksScreen
                    onDeleteTask: _deleteTask, // Provide the delete function
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $username!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildPrioritySection('High Priority', highPriorityTasks),
                  _buildPrioritySection('Medium Priority', mediumPriorityTasks),
                  _buildPrioritySection('Low Priority', lowPriorityTasks),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Navigate to the AddTaskScreen
                final newTask = await Navigator.push<Task>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(),
                  ),
                );

                // If a new task is returned, add it to the list
                if (newTask != null) {
                  _addNewTask(newTask);
                }
              },
              child: const Text('Add New Task'),
            ),
          
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context), // Sign out when tapped
            tooltip: 'Sign Out',
          ),
        ],
          
        ),
      ),
    );
  }

  Widget _buildPrioritySection(String title, List<Task> tasks) {
    return tasks.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                ...tasks.map((task) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text(
                        'Deadline: ${DateFormat.yMd().format(task.deadline)}',
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => _showTaskDetails(context, task),
                    ),
                  );
                }),
              ],
            ),
          )
        : Container();
  }
}
