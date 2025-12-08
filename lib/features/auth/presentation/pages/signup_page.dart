import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/widgets/custom_button.dart';
import 'package:rattib/core/widgets/custom_text_field.dart';
import 'package:rattib/core/utils/validators.dart';
import 'package:rattib/core/utils/helpers.dart';
import 'package:rattib/core/routes/app_routes.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/auth/presentation/widgets/social_login_buttons.dart';

/// Sign Up Page
/// User registration screen
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      Helpers.dismissKeyboard(context);

      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.signup(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        Helpers.showSuccess(context, AppStrings.signupSuccess);
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        Helpers.showError(
          context,
          authProvider.errorMessage ?? AppStrings.signupFailed,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Sign Up Title
                const Text(
                  AppStrings.signUp,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 32),
                // Name Field
                CustomTextField(
                  controller: _nameController,
                  labelText: AppStrings.name,
                  hintText: AppStrings.name,
                  keyboardType: TextInputType.name,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),
                // Email Field
                CustomTextField(
                  controller: _emailController,
                  labelText: AppStrings.email,
                  hintText: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),
                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  labelText: AppStrings.password,
                  hintText: AppStrings.password,
                  obscureText: true,
                  showPasswordToggle: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 16),
                // Confirm Password Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: AppStrings.verifyPassword,
                  hintText: AppStrings.verifyPassword,
                  obscureText: true,
                  showPasswordToggle: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: (value) => Validators.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                ),
                const SizedBox(height: 32),
                // Sign Up Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      text: AppStrings.signUp,
                      onPressed: _handleSignUp,
                      isLoading: authProvider.isLoading,
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Or Sign With
                const Text(
                  AppStrings.orSignWith,
                  style: TextStyle(
                    color: AppColors.grayText,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Social Login Buttons (UI only)
                const SocialLoginButtons(),
                const SizedBox(height: 24),
                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.alreadyHaveAccount,
                      style: TextStyle(
                        color: AppColors.grayText,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.signIn,
                        );
                      },
                      child: const Text(
                        AppStrings.signUpPrompt,
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
