import 'package:rattib/core/network/api_response.dart';
import 'package:rattib/features/auth/domain/entities/user_entity.dart';
import 'package:rattib/features/auth/domain/repositories/auth_repository.dart';

/// Signup Use Case
/// Handles user registration business logic
class SignupUseCase {
  final AuthRepository _repository;

  SignupUseCase(this._repository);

  Future<ApiResponse<UserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _repository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}
