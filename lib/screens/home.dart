import 'package:expense_manager/models/time_entry.dart';
import 'package:expense_manager/provider/project_task_provider.dart';
import 'package:expense_manager/provider/time_entry_provider.dart';
import 'package:expense_manager/screens/time_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 18),
                Text(
                  'Time Tracking',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.work,
              size: 26,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Projects',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
              ),
            ),
            onTap: () => onSelectScreen('projects'),
          ),
          ListTile(
            leading: Icon(
              Icons.task,
              size: 26,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Tasks',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
              ),
            ),
            onTap: () => onSelectScreen('tasks'),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _selectScreen(BuildContext context, String identifier) {
    if (identifier == 'projects') {
      Navigator.of(context).pushNamed('/manage', arguments: 'projects');
    } else if (identifier == 'tasks') {
      Navigator.of(context).pushNamed('/manage', arguments: 'tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MainDrawer(
          onSelectScreen: (identifier) => _selectScreen(context, identifier),
        ),
        appBar: AppBar(
          title: const Text('Time Tracking'),
          bottom: const TabBar(
            tabs: [Tab(text: 'All Entries'), Tab(text: 'Grouped by Projects')],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllEntriesTab(context),
            _buildGroupedEntriesTab(context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTimeEntryScreen()),
              ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildAllEntriesTab(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);
    final projectProvider = Provider.of<ProjectTaskProvider>(context);

    return ListView.builder(
      itemCount: provider.entries.length,
      itemBuilder: (context, index) {
        final entry = provider.entries[index];
        final project = projectProvider.projects.firstWhere(
          (p) => p.id == entry.projectId,
        );
        final task = projectProvider.tasks.firstWhere(
          (t) => t.id == entry.taskId,
        );

        return ListTile(
          title: Text('${project.name} - ${task.name}'),
          subtitle: Text(
            '${entry.totalTime} hours - ${DateFormat.yMMMd().format(entry.date)}\n'
            'Notes: ${entry.notes}',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => provider.deleteTimeEntry(entry.id as int),
          ),
        );
      },
    );
  }

  Widget _buildGroupedEntriesTab(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);
    final projectProvider = Provider.of<ProjectTaskProvider>(context);

    final Map<String, List<TimeEntry>> groupedEntries = {};
    for (final entry in provider.entries) {
      final projectName =
          projectProvider.projects
              .firstWhere((p) => p.id == entry.projectId)
              .name;
      groupedEntries.putIfAbsent(projectName, () => []).add(entry);
    }

    return ListView(
      children:
          groupedEntries.entries.map((entry) {
            return ExpansionTile(
              title: Text(entry.key),
              children:
                  entry.value.map((timeEntry) {
                    final task = projectProvider.tasks.firstWhere(
                      (t) => t.id == timeEntry.taskId,
                    );
                    return ListTile(
                      title: Text(task.name),
                      subtitle: Text(
                        '${timeEntry.totalTime} hours - ${DateFormat.yMMMd().format(timeEntry.date)}',
                      ),
                    );
                  }).toList(),
            );
          }).toList(),
    );
  }
}
