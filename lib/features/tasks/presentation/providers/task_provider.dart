import 'package:flutter/material.dart';
import 'package:rattib/core/network/api_client.dart';
import 'package:rattib/core/constants/api_constants.dart';
import 'package:rattib/features/tasks/data/models/task_model.dart';

/// Task Provider
/// Manages task state and operations
class TaskProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Get tasks by status
  List<TaskModel> getTasksByStatus(String status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  /// Fetch user tasks
  Future<void> fetchTasks(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.get<List<TaskModel>>(
      ApiConstants.tasksReadEndpoint,
      queryParameters: {'user_id': userId.toString()},
      fromJson: (data) {
        if (data is List) {
          return data
              .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <TaskModel>[];
      },
    );

    _isLoading = false;

    if (response.success && response.data != null) {
      _tasks = response.data!;
    } else {
      _errorMessage = response.message;
      _tasks = [];
    }

    notifyListeners();
  }

  /// Create new task
  Future<bool> createTask({
    required int userId,
    required String title,
    String? description,
    String? dueDate,
    String? location,
    double? latitude,
    double? longitude,
    String status = 'Pending',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.post<TaskModel>(
      ApiConstants.tasksCreateEndpoint,
      data: {
        'user_id': userId,
        'title': title,
        'description': description,
        'due_date': dueDate,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
      },
      fromJson: (data) => TaskModel.fromJson(data as Map<String, dynamic>),
    );

    _isLoading = false;

    if (response.success) {
      await fetchTasks(userId);
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  /// Update task
  Future<bool> updateTask({
    required int taskId,
    required int userId,
    required String title,
    String? description,
    String? dueDate,
    String? location,
    double? latitude,
    double? longitude,
    required String status,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.put(
      ApiConstants.tasksUpdateEndpoint,
      data: {
        'task_id': taskId,
        'user_id': userId,
        'title': title,
        'description': description,
        'due_date': dueDate,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
      },
    );

    _isLoading = false;

    if (response.success) {
      await fetchTasks(userId);
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  /// Delete task
  Future<bool> deleteTask(int taskId, int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.delete(
      ApiConstants.tasksDeleteEndpoint,
      queryParameters: {
        'id': taskId.toString(),
        'user_id': userId.toString(),
      },
    );

    _isLoading = false;

    if (response.success) {
      await fetchTasks(userId);
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
