import 'package:rattib/core/network/api_response.dart';
import 'package:rattib/features/auth/domain/repositories/auth_repository.dart';

/// Logout Use Case
/// Handles user logout business logic
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<ApiResponse<void>> call() async {
    return await _repository.logout();
  }
}
