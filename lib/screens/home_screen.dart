import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                Text("No time entries yet!",
                    style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                Text("Press + button to add your first entry",
                    style: TextStyle(color: Colors.grey[600], fontSize: 18)),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.entries.length,
          itemBuilder: (context, index) {
            final entry = provider.entries[index];
            return ListTile(
              title: Text('${entry.projectId} - ${entry.totalTime} hours'),
              subtitle:
                  Text('${entry.date.toString()} - Notes: ${entry.notes}'),
              onTap: () {
                // This could open a detailed view or edit screen
              },
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
        return ListView.builder(
          itemCount: provider.entries.length,
          itemBuilder: (context, index) {
            final entry = provider.entries[index];
            return ListTile(
              title: Text('${entry.projectId} - ${entry.totalTime} hours'),
              subtitle:
                  Text('${entry.date.toString()} - Notes: ${entry.notes}'),
              onTap: () {
                // This could open a detailed view or edit screen
              },
            );
          },
        );
      },
    );
  }
}
