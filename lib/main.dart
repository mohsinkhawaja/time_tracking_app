import 'package:flutter/material.dart';
import 'package:time_tracking_app/provider/time_entry_provider.dart';
import 'package:time_tracking_app/screens/add_timeentry_screen.dart';
import 'package:time_tracking_app/screens/home_screen.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/screens/project_taskmanagement_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;
  const MyApp({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider(localStorage)),
      ],
      child: MaterialApp(
        title: 'Time Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/manage_tasks': (context) => AddTimeEntryScreen(),
          '/manage_projects': (context) => ProjectTaskManagementScreen(),
        },
      ),
    );
  }
}
