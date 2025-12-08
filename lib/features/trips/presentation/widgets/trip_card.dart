import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/routes/app_routes.dart';
import 'package:rattib/core/utils/helpers.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/trips/data/models/trip_model.dart';
import 'package:rattib/features/trips/presentation/providers/trip_provider.dart';

/// Trip Card Widget
/// Displays trip information
class TripCard extends StatelessWidget {
  final TripModel trip;

  const TripCard({
    super.key,
    required this.trip,
  });

  void _deleteTrip(BuildContext context) async {
    final confirmed = await Helpers.showConfirmDialog(
      context,
      title: 'Delete Trip',
      message: 'Are you sure you want to delete this trip?',
      confirmText: 'Delete',
    );

    if (confirmed && context.mounted) {
      final authProvider = context.read<AuthProvider>();
      final tripProvider = context.read<TripProvider>();

      final success = await tripProvider.deleteTrip(
        trip.tripId,
        authProvider.currentUser!.userId,
      );

      if (context.mounted && success) {
        Helpers.showSuccess(context, 'Trip deleted successfully');
      }
    }
  }

  Color _getStatusColor() {
    switch (trip.status.toLowerCase()) {
      case 'completed':
        return AppColors.successGreen;
      case 'planned':
        return AppColors.primaryBlue;
      case 'cancelled':
        return AppColors.canceledStatus;
      default:
        return AppColors.grayText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.editTrip,
          arguments: trip,
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderColor,
          ),
        ),
        child: Row(
          children: [
            // Trip icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.flight_takeoff,
                color: AppColors.primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Trip details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          trip.destination,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkText,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          trip.status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _getStatusColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.iconColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trip.startDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grayText,
                        ),
                      ),
                      if (trip.endDate != null) ...[
                        const Text(
                          ' - ',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grayText,
                          ),
                        ),
                        Text(
                          trip.endDate!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grayText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Delete button
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              onPressed: () => _deleteTrip(context),
            ),
          ],
        ),
      ),
    );
  }
}
