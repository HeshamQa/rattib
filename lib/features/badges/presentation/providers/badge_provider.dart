import 'package:flutter/material.dart';
import 'package:rattib/core/network/api_client.dart';
import 'package:rattib/core/constants/api_constants.dart';
import 'package:rattib/features/badges/data/models/badge_model.dart';

/// Badge Provider
/// Manages badge state and operations
class BadgeProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<BadgeModel> _allBadges = [];
  List<BadgeModel> _userBadges = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BadgeModel> get allBadges => _allBadges;
  List<BadgeModel> get userBadges => _userBadges;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch all available badges
  Future<void> fetchAllBadges() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.get<List<BadgeModel>>(
      ApiConstants.badgesReadEndpoint,
      fromJson: (data) {
        if (data is List) {
          return data
              .map((item) => BadgeModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <BadgeModel>[];
      },
    );

    _isLoading = false;

    if (response.success && response.data != null) {
      _allBadges = response.data!;
    } else {
      _errorMessage = response.message;
      _allBadges = [];
    }

    notifyListeners();
  }

  /// Fetch user's earned badges
  Future<void> fetchUserBadges(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.get<List<BadgeModel>>(
      ApiConstants.userBadgesEndpoint,
      queryParameters: {'user_id': userId.toString()},
      fromJson: (data) {
        if (data is List) {
          return data
              .map((item) => BadgeModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <BadgeModel>[];
      },
    );

    _isLoading = false;

    if (response.success && response.data != null) {
      _userBadges = response.data!;
    } else {
      _errorMessage = response.message;
      _userBadges = [];
    }

    notifyListeners();
  }

  /// Check if user has earned a specific badge
  bool hasEarnedBadge(int badgeId) {
    return _userBadges.any((badge) => badge.badgeId == badgeId);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
