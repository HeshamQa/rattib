import 'package:flutter/material.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/utils/helpers.dart';

/// Social Login Buttons
/// UI-only placeholder for social authentication
class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        _SocialButton(
          icon: Icons.g_mobiledata,
          onTap: () {
            Helpers.showSnackBar(
              context,
              'Google login coming soon',
            );
          },
        ),
        const SizedBox(width: 16),
        // Apple
        _SocialButton(
          icon: Icons.apple,
          onTap: () {
            Helpers.showSnackBar(
              context,
              'Apple login coming soon',
            );
          },
        ),
        const SizedBox(width: 16),
        // Facebook
        _SocialButton(
          icon: Icons.facebook,
          onTap: () {
            Helpers.showSnackBar(
              context,
              'Facebook login coming soon',
            );
          },
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 32,
          color: AppColors.darkText,
        ),
      ),
    );
  }
}
