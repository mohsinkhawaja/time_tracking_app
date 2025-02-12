import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/models/project_model.dart';
import 'package:time_tracking_app/models/task_model.dart';
import 'package:time_tracking_app/provider/project_task_provider.dart';
import 'package:time_tracking_app/provider/time_entry_provider.dart';
import 'package:time_tracking_app/models/time_entry.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedProjectId;
  String? selectedTaskId;
  String notes = '';
  DateTime date = DateTime.now();
  double totalTime = 0;

  @override
  Widget build(BuildContext context) {
    final projectTaskProvider = Provider.of<ProjectTaskProvider>(context);
    final timeEntryProvider = Provider.of<TimeEntryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Add Time Entry')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // **Project Dropdown**
                DropdownButtonFormField<String>(
                  value: selectedProjectId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProjectId = newValue!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Project'),
                  items: projectTaskProvider.projects.isNotEmpty
                      ? projectTaskProvider.projects.map((Project project) {
                          return DropdownMenuItem<String>(
                            value: project.id,
                            child: Text(project.name),
                          );
                        }).toList()
                      : [
                          DropdownMenuItem(
                            value: null,
                            child: Text('No projects available'),
                          )
                        ],
                ),

                SizedBox(height: 16),

                // **Task Dropdown**
                DropdownButtonFormField<String>(
                  value: selectedTaskId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTaskId = newValue!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Task'),
                  items: projectTaskProvider.task.isNotEmpty
                      ? projectTaskProvider.task.map((Task task) {
                          return DropdownMenuItem<String>(
                            value: task.id,
                            child: Text(task.name),
                          );
                        }).toList()
                      : [
                          DropdownMenuItem(
                            value: null,
                            child: Text('No tasks available'),
                          )
                        ],
                ),

                SizedBox(height: 16),

                // **Date Picker**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: ${date.toLocal().toString().split(' ')[0]}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      child: Text('Select Date'),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != date) {
                          setState(() {
                            date = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // **Notes Field**
                TextFormField(
                  decoration: InputDecoration(labelText: 'Notes'),
                  onChanged: (value) {
                    setState(() {
                      notes = value;
                    });
                  },
                ),

                SizedBox(height: 16),

                // **Save Button**
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        timeEntryProvider.addTimeEntry(
                          TimeEntry(
                            id: DateTime.now().toString(),
                            projectId: selectedProjectId!,
                            taskId: selectedTaskId!,
                            totalTime: totalTime,
                            date: date,
                            notes: notes,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
