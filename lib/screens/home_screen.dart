import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/models/time_entry.dart';
import 'package:time_tracking_app/provider/time_entry_provider.dart';
import 'package:time_tracking_app/screens/add_timeentry_screen.dart';
import 'package:time_tracking_app/screens/project_management_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Time Tracking")),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "All Entries"),
            Tab(text: "Grouped by Project"),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Center(child: Text("Menu")),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Projects"),
              onTap: () {
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 300), () {
                  Navigator.pushNamed(context, '/manage_projects');
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text("Tasks"),
              onTap: () {
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 300), () {
                  Navigator.pushNamed(context, '/manage_tasks');
                });
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildAllTimeEntries(context),
          buildTimeGroupedByProject(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
          );
        },
        tooltip: 'Add Time Entry',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildAllTimeEntries(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No time entries yet!",
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
                Text(
                  "Press + button to add your first entry",
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: provider.entries.length,
          itemBuilder: (context, index) {
            final entry = provider.entries[index];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                title: Text(
                  '${entry.projectId} - ${entry.taskId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "Total Time: ${entry.totalTime} hours",
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      "Date: ${entry.date.toString()}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      "Note: ${entry.notes}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteTimeEntry(entry.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTimeGroupedByProject(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No time entries yet!",
                    style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                Text("Press + button to add your first entry",
                    style: TextStyle(color: Colors.grey[600], fontSize: 18)),
              ],
            ),
          );
        }

        // Group entries by projectId
        Map<String, List<TimeEntry>> groupedEntries = {};
        for (var entry in provider.entries) {
          groupedEntries.putIfAbsent(entry.projectId, () => []).add(entry);
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: groupedEntries.entries.map((project) {
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.key, // Project name
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: project.value.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            "- Task ${entry.taskId}: ${entry.totalTime} hours (${_formatDate(entry.date)})",
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

// Helper function to format date
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
