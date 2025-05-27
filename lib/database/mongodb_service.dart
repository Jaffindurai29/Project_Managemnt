import 'package:mongo_dart/mongo_dart.dart';

class MongoDbService {
  static late Db _database;
  static bool _isConnected = false;

  var db;

  Db get database => _database;
  bool get isConnected => _isConnected;

  Future<void> connect(String connectionString) async {
    // Replace with your actual MongoDB connection string
    const String mongoUri = "YOUR_MONGODB_CONNECTION_STRING";

    try {
      _database = await Db.create(mongoUri);
      await _database.open();
      _isConnected = true;
      print("Connected to MongoDB successfully!");
    } catch (e) {
      _isConnected = false;
      print("Error connecting to MongoDB: $e");
      // Consider more robust error handling
    }
  }

  Future<void> close() async {
    if (_isConnected) {
      await _database.close();
      _isConnected = false;
      print("MongoDB connection closed.");
    }
  }
}