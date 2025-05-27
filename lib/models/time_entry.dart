class TimeEntry {
  final String? id;
  final String projectId;
  final String taskId;
  final double totalTime;
  final DateTime date;
  final String notes;
  TimeEntry({
    this.id,
    required this.projectId,
    required this.taskId,
    required this.totalTime,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'taskId': taskId,
      'totalTime': totalTime,
      'date': date.toIso8601String(), // Store DateTime as ISO 8601 string
      'notes': notes,
    };
  }

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(id: json['_id']?.toString(), projectId: json['projectId'], taskId: json['taskId'], totalTime: json['totalTime'], date: DateTime.parse(json['date']), notes: json['notes']);
  }
}