import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracking_app/models/project_model.dart';
import 'package:time_tracking_app/models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;
  List<TimeEntry> _entries = [];
  final List<String> _projects = []; // Store user-added projects
  final List<String> _tasks = []; // Store user-added tasks

  // Getters
  List<TimeEntry> get entries => _entries;
  List<String> get projects => _projects;
  List<String> get tasks => _tasks;

  // Load entries from Storage
  TimeEntryProvider(this.storage) {
    _loadEntriesFromStorage();
  }

  void _loadEntriesFromStorage() async {
    var storedEntries = storage.getItem('entries');
    if (storedEntries != null) {
      _entries = List<TimeEntry>.from(
        (storedEntries as List).map((item) => TimeEntry.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}
