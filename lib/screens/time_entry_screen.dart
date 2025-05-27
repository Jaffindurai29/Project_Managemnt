import 'package:expense_manager/models/time_entry.dart';
import 'package:expense_manager/provider/project_task_provider.dart';
import 'package:expense_manager/provider/time_entry_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  State<AddTimeEntryScreen> createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProjectId;
  String? _selectedTaskId;
  double? _totalTime;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _notesController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectTaskProvider>(context);
    final timeEntryProvider = Provider.of<TimeEntryProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Time Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Project'),
                value: _selectedProjectId,
                items: projectProvider.projects.map((project) {
                  return DropdownMenuItem<String>(
                    value: project.id,
                    child: Text(project.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedProjectId = value),
                validator: (value) => value == null ? 'Select a project' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Task'),
                value: _selectedTaskId,
                items: projectProvider.tasks.map((task) {
                  return DropdownMenuItem<String>(
                    value: task.id,
                    child: Text(task.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedTaskId = value),
                validator: (value) => value == null ? 'Select a task' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter time';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
                onSaved: (value) => _totalTime = double.parse(value!),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(DateFormat.yMMMd().format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    timeEntryProvider.addTimeEntry(TimeEntry(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      projectId: _selectedProjectId!,
                      taskId: _selectedTaskId!,
                      totalTime: _totalTime!,
                      date: _selectedDate,
                      notes: _notesController.text,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}