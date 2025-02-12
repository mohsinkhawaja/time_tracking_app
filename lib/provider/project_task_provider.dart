import 'package:flutter/material.dart';
import 'package:time_tracking_app/models/project_model.dart';
import 'package:time_tracking_app/models/task_model.dart';

class ProjectTaskProvider with ChangeNotifier {
  // List of projects
  final List<Project> _projects = [
    Project(id: '1', name: 'Project1'),
    Project(id: '2', name: 'Project2')
  ];
  // List of Tasks
  final List<Task> _tasks = [
    Task(id: '1', name: 'Task1'),
    Task(id: '2', name: 'Task2')
  ];

  List<Project> get projects => _projects;
  List<Task> get task => _tasks;

  void addProject(Project projects) {
    if (!_projects.any((pro) => pro.name == projects.name)) {
      _projects.add(projects);
      notifyListeners();
    }
  }

  // Delete a category
  void deleteProject(String id) {
    _projects.removeWhere((projects) => projects.id == id);
    notifyListeners();
  }

  // Add a task
  void addTask(Task task) {
    if (!_tasks.any((t) => t.name == task.name)) {
      _tasks.add(task);
      notifyListeners();
    }
  }

  // Delete a task
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
