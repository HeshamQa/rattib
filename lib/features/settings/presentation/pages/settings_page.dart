import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/routes/app_routes.dart';
import 'package:rattib/core/utils/helpers.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';

/// Settings Page
/// User settings and preferences
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _handleSignOut(BuildContext context) async {
    final confirmed = await Helpers.showConfirmDialog(
      context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      confirmText: 'Sign Out',
    );

    if (confirmed && context.mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.welcome,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                    child: Text(
                      user?.name.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'User',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.grayText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: AppColors.primaryBlue,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.editProfile);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Settings Sections
            _buildSectionTitle('Preferences'),
            const SizedBox(height: 12),
            _buildSettingsTile(
              context,
              icon: Icons.language,
              title: AppStrings.language,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.language);
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('About & Support'),
            const SizedBox(height: 12),
            _buildSettingsTile(
              context,
              icon: Icons.privacy_tip,
              title: AppStrings.privacyPolicy,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.privacyPolicy);
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.warning_amber_rounded,
              title: "SOS Emergency",
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () {
                Helpers.showConfirmDialog(
                  context,
                  title: "SOS",
                  message: "Are you in an emergency?",
                  confirmText: "Send SOS",
                ).then((confirmed) {
                  if (confirmed) {
                    Helpers.showSnackBar(
                      context,
                      "SOS alert sent! (Coming soon)",
                    );
                  }
                });
              },
            ),
            const SizedBox(height: 24),
            _buildSettingsTile(
              context,
              icon: Icons.description,
              title: AppStrings.termsConditions,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.termsConditions);
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.star,
              title: AppStrings.ratingFeedback,
              onTap: () {
                Helpers.showSuccess(context, 'Rating feature coming soon!');
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.contact_support,
              title: AppStrings.contactUs,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.contactUs);
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.info,
              title: AppStrings.aboutUs,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.aboutUs);
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.help,
              title: AppStrings.helpFaqs,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.helpFaqs);
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Account'),
            const SizedBox(height: 12),
            _buildSettingsTile(
              context,
              icon: Icons.logout,
              title: AppStrings.signOut,
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () => _handleSignOut(context),
            ),
            const SizedBox(height: 32),
            // App Version
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grayText.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.grayText,
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.iconColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? AppColors.darkText,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.grayText.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
