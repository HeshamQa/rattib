/// Task Model
/// Data layer representation of a task
class TaskModel {
  final int taskId;
  final String title;
  final String? description;
  final String? dueDate;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String status;
  final String? createdAt;

  const TaskModel({
    required this.taskId,
    required this.title,
    this.description,
    this.dueDate,
    this.location,
    this.latitude,
    this.longitude,
    required this.status,
    this.createdAt,
  });

  /// Create TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['task_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['due_date'] as String?,
      location: json['location'] as String?,
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      status: json['status'] as String? ?? 'Pending',
      createdAt: json['created_at'] as String?,
    );
  }

  /// Convert TaskModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'created_at': createdAt,
    };
  }
}
