import 'package:rattib/core/network/api_response.dart';
import 'package:rattib/features/auth/domain/entities/user_entity.dart';

/// Authentication Repository Interface
/// Defines the contract for authentication operations
abstract class AuthRepository {
  Future<ApiResponse<UserEntity>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<ApiResponse<UserEntity>> login({
    required String email,
    required String password,
  });

  Future<ApiResponse<void>> logout();

  Future<ApiResponse<void>> forgotPassword({required String email});
}
