import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:time_tracking_app/models/task_model.dart';
import 'package:time_tracking_app/provider/project_task_provider.dart';
import 'package:uuid/uuid.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Tasks')),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.task.length,
            itemBuilder: (context, index) {
              final task = provider.task[index];
              return ListTile(
                title: Text(task.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteTask(task.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Function to show Add Task Dialog
  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(labelText: "Task Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final taskName = taskController.text.trim();
                if (taskName.isNotEmpty) {
                  var uuid = const Uuid();
                  Provider.of<ProjectTaskProvider>(context, listen: false)
                      .addTask(Task(id: uuid.v4(), name: taskName));
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
