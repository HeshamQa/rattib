import 'package:rattib/core/network/api_response.dart';
import 'package:rattib/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:rattib/features/auth/domain/entities/user_entity.dart';
import 'package:rattib/features/auth/domain/repositories/auth_repository.dart';

/// Authentication Repository Implementation
/// Implements the auth repository interface
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  @override
  Future<ApiResponse<UserEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: response.data!.toEntity(),
        message: response.message,
      );
    }

    return ApiResponse.error(message: response.message ?? 'Registration failed');
  }

  @override
  Future<ApiResponse<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: response.data!.toEntity(),
        message: response.message,
      );
    }

    return ApiResponse.error(message: response.message ?? 'Login failed');
  }

  @override
  Future<ApiResponse<void>> logout() async {
    return await _remoteDataSource.logout();
  }

  @override
  Future<ApiResponse<void>> forgotPassword({required String email}) async {
    return await _remoteDataSource.forgotPassword(email: email);
  }

  @override
  Future<ApiResponse<UserEntity>> updateProfile({
    required int userId,
    required String name,
    required String email,
  }) async {
    final response = await _remoteDataSource.updateProfile(
      userId: userId,
      name: name,
      email: email,
    );

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: response.data!.toEntity(),
        message: response.message,
      );
    }

    return ApiResponse.error(message: response.message ?? 'Profile update failed');
  }
}
