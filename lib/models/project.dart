class Project {
  final String id;
  final String name;

  Project({required this.id, required this.name});

  // Convert Project object to a MongoDB document (Map)
  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Use '_id' for MongoDB
      'name': name,
    };
  }

  // Create a Project object from a MongoDB document (Map)
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'] as String, // Retrieve from '_id'
      name: json['name'] as String,
    );
  }
}