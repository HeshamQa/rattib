import 'package:rattib/core/constants/app_strings.dart';

/// Form Validators
/// Contains validation functions for form fields
class Validators {
  /// Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }

    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return AppStrings.emailInvalid;
    }

    return null;
  }

  /// Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value.length < 8) {
      return AppStrings.passwordTooShort;
    }

    return null;
  }

  /// Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value != password) {
      return AppStrings.passwordsDoNotMatch;
    }

    return null;
  }

  /// Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.nameRequired;
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  /// Required field validation
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName is required' : AppStrings.fieldRequired;
    }
    return null;
  }

  /// Phone number validation (optional)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    // Basic phone number pattern (digits only, 10-15 characters)
    final phoneRegex = RegExp(r'^\d{10,15}$');

    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-()]'), ''))) {
      return 'Please enter a valid phone number';
    }

    return null;
  }
}
