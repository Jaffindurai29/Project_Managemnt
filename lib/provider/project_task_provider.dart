import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../database/mongodb_data_service.dart';

class ProjectTaskProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<Task> _tasks = [];

  ProjectTaskProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _projects = await MongoDbDataService().getProjects();
    _tasks = await MongoDbDataService().getTasks();
    notifyListeners();
  }

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  Future<void> addProject(Project project) async {
    await MongoDbDataService().insertProject(project);
    await _loadData();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await MongoDbDataService().insertTask(task);
    await _loadData();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await MongoDbDataService().deleteTask(id);
    await _loadData();
    notifyListeners();
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((project) => project.id == id.toString()); // Assuming project id is String
    _tasks.removeWhere((task) => task.projectId == id.toString()); // Assuming task projectId is String
    _projects = await MongoDbDataService().getProjects();
    _tasks = await MongoDbDataService().getTasks();
    notifyListeners();
  }

  // Add methods for updating if needed
  Future<void> updateProject(Project project) async {
    await MongoDbDataService().updateProject(project);
  //   await _loadData(); // Reload all data after update
    await _loadData();
  }
  // Future<void> updateTask(Task task) async {
  //   await DatabaseHelper().updateTask(task);
  //   await _loadData(); // Reload all data after update
  // }
}
