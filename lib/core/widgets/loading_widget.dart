import 'package:flutter/material.dart';
import 'package:rattib/core/constants/app_colors.dart';

/// Loading Widget
/// Displays a loading indicator
class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;

  const LoadingWidget({
    super.key,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: color ?? AppColors.primaryBlue,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                color: AppColors.grayText,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
