import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/provider/project_task_provider.dart';

class ProjectTaskManagementScreen extends StatelessWidget {
  const ProjectTaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Projects and Tasks'),
      ),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Text(
                'Lists for managing projects and tasks would be implemented here'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "routeName");
        },
        tooltip: 'Add Project/Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
