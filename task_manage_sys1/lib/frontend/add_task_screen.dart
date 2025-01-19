// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:task_manage_sys1/models/task.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController subtaskController = TextEditingController();
  String selectedPriority = 'Medium'; // Default value
  String selectedCategory = 'Personal'; // Default value

  DateTime selectedDate = DateTime.now();
  final List<Subtask> subtasks = [];

  void _addSubtask() {
    if (subtaskController.text.isNotEmpty) {
      setState(() {
        subtasks.add(Subtask(subtaskController.text, false));
        subtaskController.clear(); // Clear input after adding
      });
    }
  }

  void _saveTask() {
    final String title = titleController.text;
    final String description = descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      final Task newTask = Task(
        title: title,
        description: description,
        deadline: selectedDate,
        subtasks: subtasks,
        priority: selectedPriority,
        category: selectedCategory,
      );

      // Return the new task to the HomeScreen
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedPriority,
              items: ['High', 'Medium', 'Low'].map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPriority = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedCategory,
              items: ['Meetings', 'Projects', 'Personal'].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            const Text('Select Deadline'),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: const Text('Pick a Date'),
            ),
            const SizedBox(height: 10),
            Text('Selected Date: ${DateFormat.yMd().format(selectedDate)}'),
            const SizedBox(height: 10),
            TextField(
              controller: subtaskController,
              decoration: const InputDecoration(
                labelText: 'Subtask Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addSubtask,
              child: const Text('Add Subtask'),
            ),
            const SizedBox(height: 10),
            const Text('Subtasks:'),
            Column(
              children: subtasks.map((subtask) {
                return ListTile(
                  title: Text(subtask.title),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
