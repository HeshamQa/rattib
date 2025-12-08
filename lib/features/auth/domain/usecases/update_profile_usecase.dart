import 'package:rattib/core/network/api_response.dart';
import 'package:rattib/features/auth/domain/entities/user_entity.dart';
import 'package:rattib/features/auth/domain/repositories/auth_repository.dart';

/// Update Profile Use Case
/// Handles user profile update business logic
class UpdateProfileUseCase {
  final AuthRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<ApiResponse<UserEntity>> call({
    required int userId,
    required String name,
    required String email,
  }) async {
    return await _repository.updateProfile(
      userId: userId,
      name: name,
      email: email,
    );
  }
}
