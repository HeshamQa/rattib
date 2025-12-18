import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rattib/features/auth/domain/entities/user_entity.dart';
import 'package:rattib/features/auth/domain/usecases/login_usecase.dart';
import 'package:rattib/features/auth/domain/usecases/signup_usecase.dart';
import 'package:rattib/features/auth/domain/usecases/logout_usecase.dart';
import 'package:rattib/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:rattib/features/auth/data/repositories/auth_repository_impl.dart';

/// Authentication Provider
/// Manages authentication state and operations
class AuthProvider with ChangeNotifier {
  // Use cases
  late final LoginUseCase _loginUseCase;
  late final SignupUseCase _signupUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final UpdateProfileUseCase _updateProfileUseCase;

  // State
  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  // Getters
  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  int? get adminId => _currentUser?.adminId;
  String? get role => _currentUser?.role;

  AuthProvider() {
    final repository = AuthRepositoryImpl();
    _loginUseCase = LoginUseCase(repository);
    _signupUseCase = SignupUseCase(repository);
    _logoutUseCase = LogoutUseCase(repository);
    _updateProfileUseCase = UpdateProfileUseCase(repository);
    _loadUserFromStorage();
  }

  /// Load user from local storage
  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
      final userId = prefs.getInt('user_id');
      final name = prefs.getString('user_name');
      final email = prefs.getString('user_email');
      final isAdmin = prefs.getBool('is_admin') ?? false;
      final adminId = prefs.getInt('admin_id');
      final role = prefs.getString('role');

      if (isAuthenticated && userId != null && name != null && email != null) {
        _currentUser = UserEntity(
          userId: userId,
          name: name,
          email: email,
          isAdmin: isAdmin,
          adminId: adminId,
          role: role,
        );
        notifyListeners();
      }
    } catch (e) {
      // Ignore errors during load
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Save user to local storage
  Future<void> _saveUserToStorage(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user.userId);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setBool('isAuthenticated', true);
    await prefs.setBool('is_admin', user.isAdmin);
    if (user.adminId != null) {
      await prefs.setInt('admin_id', user.adminId!);
    }
    if (user.role != null) {
      await prefs.setString('role', user.role!);
    }
  }

  /// Clear user from local storage
  Future<void> _clearUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('isAuthenticated');
    await prefs.remove('is_admin');
    await prefs.remove('admin_id');
    await prefs.remove('role');
  }

  /// Login
  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _loginUseCase(email: email, password: password);

    _isLoading = false;

    if (response.success && response.data != null) {
      _currentUser = response.data;
      await _saveUserToStorage(_currentUser!);
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  /// Sign up
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _signupUseCase(
      name: name,
      email: email,
      password: password,
    );

    _isLoading = false;

    if (response.success && response.data != null) {
      _currentUser = response.data;
      await _saveUserToStorage(_currentUser!);
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _logoutUseCase();
    await _clearUserFromStorage();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Update profile
  Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    if (_currentUser == null) {
      _errorMessage = 'User not logged in';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _updateProfileUseCase(
      userId: _currentUser!.userId,
      name: name,
      email: email,
    );

    _isLoading = false;

    if (response.success && response.data != null) {
      _currentUser = response.data;
      await _saveUserToStorage(_currentUser!);
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
