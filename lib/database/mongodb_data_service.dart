import 'package:mongo_dart/mongo_dart.dart'  hide Project;
import '../models/project.dart';
import '../models/task.dart';
import '../models/time_entry.dart';
import 'mongodb_service.dart';

class MongoDbDataService {
  final MongoDbService _dbService = MongoDbService();

  DbCollection? _projectsCollection;
  DbCollection? _tasksCollection;
  DbCollection? _timeEntriesCollection;

  DbCollection get _projects =>
      _projectsCollection ??= _dbService.database.collection('projects');
  DbCollection get _tasks =>
      _tasksCollection ??= _dbService.database.collection('tasks');
  DbCollection get _timeEntries =>
      _timeEntriesCollection ??= _dbService.database.collection('timeEntries');

  // Project CRUD operations

  Future<List<Project>> getProjects() async {
    if (!_dbService.database.isConnected) {
      // Handle connection not open
      return [];
    }
    final List<Map<String, dynamic>> projects = (await _projects.find().toList()).cast<Map<String, dynamic>>(); // Explicit cast for safety
    // Convert the list of dynamic maps to a List<Project>

    return projects.map((json) => Project.fromJson(json)).toList();
  }

  Future<void> insertProject(Project project) async {
    if (_dbService.db == null || !_dbService.db!.isConnected) {
 // Handle connection not open
      return;
    }
    // MongoDB generates _id automatically on insert if not provided
    await _projects.insertOne(project.toJson());
  }

  Future<void> updateProject(Project project) async {
    if (_dbService.db == null || !_dbService.db!.isConnected) {
 // Handle connection not open
      return;
    }
    await _projects.replaceOne(where.id(ObjectId.parse(project.id)), project.toJson());
  }

  Future<void> deleteProject(String id) async {
    if (_dbService.db == null || !_dbService.db!.isConnected) {
 // Handle connection not open
      return;
    }
    await _projects.deleteOne(where.id(ObjectId.parse(id)));
  }

  // Task CRUD operations

  Future<List<Task>> getTasks() async {
    if (!_dbService.database.isConnected) {
      // Handle connection not open
      return [];
    }
    final List<Map<String, dynamic>> tasks = (await _tasks.find().toList()).cast<Map<String, dynamic>>();
    return tasks.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> insertTask(Task task) async {
    if (_dbService.db == null || !_dbService.db!.isConnected) {
 // Handle connection not open
      return;
    }
    await _tasks.insertOne(task.toJson());
  }

  Future<void> updateTask(Task task) async {
    if (_dbService.db == null || !_dbService.db!.isConnected) {
 // Handle connection not open
      return;
    }
    await _tasks.replaceOne(where.id(ObjectId.parse(task.id)), task.toJson());
  }

  Future<void> deleteTask(String id) async {
    if (_dbService.db == null || !_dbService.db!.isConnected) {
 // Handle connection not open
      return;
    }
    await _tasks.deleteOne(where.id(ObjectId.parse(id)));
  }

  // TimeEntry CRUD operations

  Future<List<TimeEntry>> getTimeEntries() async {
    if (!_dbService.database.isConnected) {
      // Handle connection not open
      return [];
    }
    final List<Map<String, dynamic>> timeEntries = (await _timeEntries.find().toList()).cast<Map<String, dynamic>>();
    return timeEntries.map((json) => TimeEntry.fromJson(json)).toList();
  }

  Future<void> insertTimeEntry(TimeEntry timeEntry) async {
    if (_dbService.db == null || !_dbService.db!.isConnected) {
 // Handle connection not open
      return;
    }
    await _timeEntries.insertOne(timeEntry.toJson());
  }

  Future<void> updateTimeEntry(TimeEntry timeEntry) async {
    if (_dbService.db == null || !_dbService.db!.isConnected) {
 // Handle connection not open
      return;
    }
     if (timeEntry.id == null) {
      // Cannot update without an ID
      return;
    }
    await _timeEntries.replaceOne(where.id(ObjectId.parse(timeEntry.id!)), timeEntry.toJson());
  }

  Future<void> deleteTimeEntry(String id) async {
    if (_dbService.db == null || !_dbService.db!.isConnected) {
 // Handle connection not open
      return;
    }
    await _timeEntries.deleteOne(where.id(ObjectId.parse(id)));
  }
}