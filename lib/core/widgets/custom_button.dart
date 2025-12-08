import 'package:flutter/material.dart';
import 'package:rattib/core/constants/app_colors.dart';

/// Custom Button Widget
/// Reusable button component matching app design
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    this.textColor,
    this.width,
    this.height = 50,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.primaryButton;
    final buttonTextColor = textColor ?? AppColors.white;

    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: (isLoading || onPressed == null) ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: buttonColor, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: buttonColor,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: buttonColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: (isLoading || onPressed == null) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor: AppColors.disabledButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: buttonTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
