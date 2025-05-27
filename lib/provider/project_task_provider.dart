import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/task.dart';

class ProjectTaskProvider with ChangeNotifier {
  final List<Project> _projects = [
    Project(id: '1', name: 'Project Alpha'),
    Project(id: '2', name: 'Project Beta'),
    Project(id: '3', name: 'Project Gamma'),
  ];

  final List<Task> _tasks = [
    Task(id: '1', name: 'Task A', projectId: '1'),
    Task(id: '2', name: 'Task B', projectId: '2'),
    Task(id: '3', name: 'Task C', projectId: '3'),
    Task(id: '4', name: 'Task D', projectId: '1'),
    Task(id: '5', name: 'Task E', projectId: '2'),
  ];

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _tasks.removeWhere((task) => task.projectId == id);
    notifyListeners();
  }
}
