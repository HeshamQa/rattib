import 'package:rattib/core/network/api_client.dart';
import 'package:rattib/core/network/api_response.dart';
import 'package:rattib/core/constants/api_constants.dart';
import 'package:rattib/features/auth/data/models/user_model.dart';

/// Authentication Remote Data Source
/// Handles API calls for authentication
class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Register new user
  Future<ApiResponse<UserModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<UserModel>(
      ApiConstants.registerEndpoint,
      data: {'name': name, 'email': email, 'password': password},
      fromJson: (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );

    return response;
  }

  /// Login user
  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<UserModel>(
      ApiConstants.loginEndpoint,
      data: {'email': email, 'password': password},
      fromJson: (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );

    return response;
  }

  /// Logout user
  Future<ApiResponse<void>> logout() async {
    final response = await _apiClient.post<void>(ApiConstants.logoutEndpoint);

    return response;
  }

  /// Forgot password
  Future<ApiResponse<void>> forgotPassword({required String email}) async {
    final response = await _apiClient.post<void>(
      ApiConstants.forgotPasswordEndpoint,
      data: {'email': email},
    );

    return response;
  }
}
