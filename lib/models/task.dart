class Task {
  final String id;
  final String name;
  final String projectId;

  Task({required this.id, required this.name, required this.projectId});

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // MongoDB uses _id
      'name': name,
      'projectId': projectId,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(id: json['_id'] as String, name: json['name'] as String, projectId: json['projectId'] as String);
  }
}