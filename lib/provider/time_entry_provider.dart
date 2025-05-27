import 'package:expense_manager/database/database_helper.dart';
import 'package:flutter/material.dart';
import '../models/time_entry.dart';
import '../database/mongodb_data_service.dart'; // Import the new service

class TimeEntryProvider with ChangeNotifier {
  List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => _entries;

  // Initialize with data loading
  TimeEntryProvider() { _loadTimeEntries(); }

  Future<void> _loadTimeEntries() async {
    _entries = await MongoDbDataService().getTimeEntries(); // Use MongoDbDataService
    notifyListeners();
  }

  Future<void> addTimeEntry(TimeEntry entry) async {
    await MongoDbDataService().insertTimeEntry(entry); // Use MongoDbDataService
    // Reload all entries after insertion to get the new entry with its MongoDB _id
    _entries = await MongoDbDataService().getTimeEntries();
    notifyListeners();
  }

  // Note: TimeEntry model likely needs an ID field for deletion.
  // Assuming TimeEntry has an 'id' property of type int.
  Future<void> deleteTimeEntry(int id) async {
    await DatabaseHelper().deleteTimeEntry(id);
    _entries.removeWhere((entry) => entry.id == id); // Assuming entry has an ID field that maps to MongoDB's _id
    // _entries = await DatabaseHelper().getTimeEntries(); // Or reload from database
    notifyListeners();
  }
}