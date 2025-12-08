import 'package:flutter/material.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/features/badges/data/models/badge_model.dart';

/// Badge Card Widget
/// Displays badge information
class BadgeCard extends StatelessWidget {
  final BadgeModel badge;
  final bool isEarned;

  const BadgeCard({
    super.key,
    required this.badge,
    this.isEarned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEarned
              ? AppColors.successGreen.withOpacity(0.3)
              : AppColors.borderColor,
        ),
      ),
      child: Column(
        children: [
          // Badge Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isEarned
                  ? AppColors.primaryBlue.withOpacity(0.1)
                  : AppColors.grayText.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.emoji_events,
                size: 40,
                color: isEarned ? AppColors.primaryBlue : AppColors.grayText,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Badge Name
          Text(
            badge.badgeName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isEarned ? AppColors.darkText : AppColors.grayText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Badge Description
          Text(
            badge.description,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grayText,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isEarned && badge.earnedAt != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Earned',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.successGreen,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
