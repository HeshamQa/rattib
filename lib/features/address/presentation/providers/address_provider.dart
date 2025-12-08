import 'package:flutter/material.dart';
import 'package:rattib/core/network/api_client.dart';
import 'package:rattib/core/constants/api_constants.dart';
import 'package:rattib/features/address/data/models/address_model.dart';

/// Address Provider
/// Manages address state and operations
class AddressProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<AddressModel> _addresses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AddressModel> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch user addresses
  Future<void> fetchAddresses(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.get<List<AddressModel>>(
      ApiConstants.addressesReadEndpoint,
      queryParameters: {'user_id': userId.toString()},
      fromJson: (data) {
        if (data is List) {
          return data
              .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <AddressModel>[];
      },
    );

    _isLoading = false;

    if (response.success && response.data != null) {
      _addresses = response.data!;
    } else {
      _errorMessage = response.message;
      _addresses = [];
    }

    notifyListeners();
  }

  /// Create new address
  Future<bool> createAddress({
    required int userId,
    required String addressType,
    required String addressLine,
    double? latitude,
    double? longitude,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.post<AddressModel>(
      ApiConstants.addressesCreateEndpoint,
      data: {
        'user_id': userId,
        'address_type': addressType,
        'address_line': addressLine,
        'latitude': latitude,
        'longitude': longitude,
      },
      fromJson: (data) => AddressModel.fromJson(data as Map<String, dynamic>),
    );

    _isLoading = false;

    if (response.success) {
      // Refresh addresses list
      await fetchAddresses(userId);
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  /// Delete address
  Future<bool> deleteAddress(int addressId, int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiClient.delete(
      ApiConstants.addressesDeleteEndpoint,
      queryParameters: {
        'id': addressId.toString(),
        'user_id': userId.toString(),
      },
    );

    _isLoading = false;

    if (response.success) {
      // Refresh addresses list
      await fetchAddresses(userId);
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
