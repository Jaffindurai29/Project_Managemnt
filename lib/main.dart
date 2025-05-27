import 'package:expense_manager/database/mongodb_service.dart';
import 'package:expense_manager/provider/project_task_provider.dart';
import 'package:expense_manager/provider/time_entry_provider.dart';

import 'package:expense_manager/screens/home.dart';
import 'package:expense_manager/screens/task_management.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDbService().connect("YOUR_MONGODB_CONNECTION_STRING"); // Connect to MongoDB
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider()),
        ChangeNotifierProvider(create: (_) => ProjectTaskProvider()),
      ],
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
        routes: {'/manage': (context) => const ProjectTaskScreen()},
      ),
    );
  }
}
