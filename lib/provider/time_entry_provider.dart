import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracking_app/models/project_model.dart';
import 'package:time_tracking_app/models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;
  List<TimeEntry> _entries = [];

  // Getters
  List<TimeEntry> get entries => _entries;

  // Load entries from Storage
  TimeEntryProvider(this.storage) {
    _loadEntriesFromStorage();
  }

  void _loadEntriesFromStorage() async {
    var storedEntries = storage.getItem('entries');
    if (storedEntries != null) {
      _entries = List<TimeEntry>.from(
        (storedEntries as List).map((item) => Project.fromJson(item)),
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

  // void _saveTimeEntryToStorage() {
  //   storage.setItem(
  //       'entries', jsonEncode(_entries.map((e) => e.toJson()).toList()));
  // }
  // Add a Project
}
