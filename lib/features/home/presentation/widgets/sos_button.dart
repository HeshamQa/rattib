import 'package:flutter/material.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/utils/helpers.dart';

/// SOS Button
/// Emergency button widget
class SOSButton extends StatelessWidget {
  const SOSButton({super.key});

  void _handleSOSPress(BuildContext context) {
    Helpers.showConfirmDialog(
      context,
      title: AppStrings.sos,
      message: 'Are you in an emergency? This will send alerts to your emergency contacts.',
      confirmText: 'Send SOS',
      cancelText: 'Cancel',
    ).then((confirmed) {
      if (confirmed) {
        Helpers.showSnackBar(
          context,
          'SOS alert sent! (Feature coming soon)',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,   // ← مش بنص
      child: InkWell(
        onTap: () => _handleSOSPress(context),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.sosRed,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppColors.sosRed.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // ← زر صغير
            children: const [
              Icon(
                Icons.warning_rounded,
                color: AppColors.white,
                size: 15,
              ),
              SizedBox(width: 8),
              Text(
                AppStrings.sos,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
