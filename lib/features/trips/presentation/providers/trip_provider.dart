import 'package:flutter/material.dart';
import 'package:rattib/core/network/api_client.dart';
import 'package:rattib/core/constants/api_constants.dart';
import 'package:rattib/features/trips/data/models/trip_model.dart';

/// Trip Provider
/// Manages trip state and operations
class TripProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<TripModel> _trips = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TripModel> get trips => _trips;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Get trips by status
  List<TripModel> getTripsByStatus(String status) {
    return _trips.where((trip) => trip.status == status).toList();
  }

  /// Fetch user trips
  Future<void> fetchTrips(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.get<List<TripModel>>(
      ApiConstants.tripsReadEndpoint,
      queryParameters: {'user_id': userId.toString()},
      fromJson: (data) {
        if (data is List) {
          return data
              .map((item) => TripModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <TripModel>[];
      },
    );

    _isLoading = false;

    if (response.success && response.data != null) {
      _trips = response.data!;
    } else {
      _errorMessage = response.message;
      _trips = [];
    }

    notifyListeners();
  }

  /// Create new trip
  Future<bool> createTrip({
    required int userId,
    required String destination,
    required String startDate,
    String? endDate,
    String status = 'Planned',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.post<TripModel>(
      ApiConstants.tripsCreateEndpoint,
      data: {
        'user_id': userId,
        'destination': destination,
        'start_date': startDate,
        'end_date': endDate,
        'status': status,
      },
      fromJson: (data) => TripModel.fromJson(data as Map<String, dynamic>),
    );

    _isLoading = false;

    if (response.success) {
      await fetchTrips(userId);
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  /// Update trip
  Future<bool> updateTrip({
    required int tripId,
    required int userId,
    required String destination,
    required String startDate,
    String? endDate,
    required String status,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.put(
      ApiConstants.tripsUpdateEndpoint,
      data: {
        'trip_id': tripId,
        'user_id': userId,
        'destination': destination,
        'start_date': startDate,
        'end_date': endDate,
        'status': status,
      },
    );

    _isLoading = false;

    if (response.success) {
      await fetchTrips(userId);
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  /// Delete trip
  Future<bool> deleteTrip(int tripId, int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.delete(
      ApiConstants.tripsDeleteEndpoint,
      queryParameters: {
        'id': tripId.toString(),
        'user_id': userId.toString(),
      },
    );

    _isLoading = false;

    if (response.success) {
      await fetchTrips(userId);
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
