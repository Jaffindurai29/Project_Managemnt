import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService {
  static const String _connectionString = 'mongodb://localhost:27017/expense_manager';
  static Db? _database;
  static DbCollection? _expensesCollection;

  static Future<void> connect() async {
    try {
      _database = Db(_connectionString);
      await _database!.open();
      _expensesCollection = _database!.collection('expenses');
      print('Connected to MongoDB successfully');
    } catch (e) {
      print('Error connecting to MongoDB: $e');
      throw Exception('Failed to connect to database');
    }
  }

  static Future<void> disconnect() async {
    if (_database != null) {
      await _database!.close();
      print('Disconnected from MongoDB');
    }
  }

  static DbCollection get expensesCollection {
    if (_expensesCollection == null) {
      throw Exception('Database not connected');
    }
    return _expensesCollection!;
  }

  static bool get isConnected => _database?.isConnected ?? false;
}