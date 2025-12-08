import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/widgets/custom_button.dart';
import 'package:rattib/core/widgets/custom_text_field.dart';
import 'package:rattib/core/utils/validators.dart';
import 'package:rattib/core/utils/helpers.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';

/// Profile Edit Page
/// Edit user profile information
class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      Helpers.dismissKeyboard(context);

      final authProvider = context.read<AuthProvider>();

      // Show loading indicator
      Helpers.showLoadingDialog(context);

      final success = await authProvider.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );

      // Hide loading indicator
      if (mounted) {
        Helpers.hideLoadingDialog(context);
      }

      if (success) {
        if (mounted) {
          Helpers.showSuccess(context, 'Profile updated successfully!');
          // Go back to settings page
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          Helpers.showError(
            context,
            authProvider.errorMessage ?? 'Failed to update profile. Please try again.',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Picture
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                        child: Text(
                          _nameController.text.isNotEmpty
                              ? _nameController.text.substring(0, 1).toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Name Field
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  prefixIcon: const Icon(Icons.person),
                  validator: (value) =>
                      Validators.validateRequired(value, fieldName: 'Name'),
                ),
                const SizedBox(height: 16),
                // Email Field
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 32),
                // Save Button
                CustomButton(
                  text: 'Save Changes',
                  onPressed: _saveProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
