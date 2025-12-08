import 'package:rattib/core/network/api_response.dart';
import 'package:rattib/features/auth/domain/entities/user_entity.dart';
import 'package:rattib/features/auth/domain/repositories/auth_repository.dart';

/// Login Use Case
/// Handles user login business logic
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<ApiResponse<UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await _repository.login(
      email: email,
      password: password,
    );
  }
}
