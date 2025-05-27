import 'package:expense_manager/models/project.dart';
import 'package:expense_manager/models/task.dart';
import 'package:expense_manager/provider/project_task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectTaskScreen extends StatelessWidget {
  const ProjectTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectTaskProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Projects & Tasks'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Projects'), Tab(text: 'Tasks')],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProjectList(context, provider.projects),
            _buildTaskList(context, provider.tasks),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildProjectList(BuildContext context, List<Project> projects) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder:
          (context, index) => ListTile(
            title: Text(projects[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                final projectProvider = Provider.of<ProjectTaskProvider>(
                  context,
                  listen: false,
                );
                projectProvider.deleteProject(projects[index].id);
              },
            ),
          ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder:
          (context, index) => ListTile(
            title: Text(tasks[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                final projectProvider = Provider.of<ProjectTaskProvider>(
                  context,
                  listen: false,
                );
                projectProvider.deleteTask(tasks[index].id);
              },
            ),
          ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Add Project'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAddForm(context, isProject: true);
                  },
                ),
                ListTile(
                  title: const Text('Add Task'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAddForm(context, isProject: false);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showAddForm(BuildContext context, {required bool isProject}) {
    final TextEditingController controller = TextEditingController();
    final provider = Provider.of<ProjectTaskProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isProject ? 'Add Project' : 'Add Task'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: isProject ? 'Project Name' : 'Task Name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                    if (isProject) {
                      provider.addProject(
                        Project(id: id, name: controller.text),
                      );
                    } else {
                      provider.addTask(
                        Task(id: id, name: controller.text, projectId: id),
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}
