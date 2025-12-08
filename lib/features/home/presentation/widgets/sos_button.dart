import 'package:flutter/material.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/utils/helpers.dart';

/// SOS Button
/// Emergency button widget
class SOSButton extends StatelessWidget {
  const SOSButton({super.key});

  void _handleSOSPress(BuildContext context) {
    // Show confirmation dialog
    Helpers.showConfirmDialog(
      context,
      title: AppStrings.sos,
      message: 'Are you in an emergency? This will send alerts to your emergency contacts.',
      confirmText: 'Send SOS',
      cancelText: 'Cancel',
    ).then((confirmed) {
      if (confirmed) {
        // TODO: Implement SOS functionality
        Helpers.showSnackBar(
          context,
          'SOS alert sent! (Feature coming soon)',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleSOSPress(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.sosRed,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.sosRed.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: AppColors.sosRed,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              AppStrings.sos,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
