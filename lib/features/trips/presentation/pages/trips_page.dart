import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/routes/app_routes.dart';
import 'package:rattib/core/widgets/loading_widget.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/trips/presentation/providers/trip_provider.dart';
import 'package:rattib/features/trips/presentation/widgets/trip_card.dart';

/// Trips Page
/// View and manage trips
class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTrips();
    });
  }

  void _loadTrips() {
    final authProvider = context.read<AuthProvider>();
    final tripProvider = context.read<TripProvider>();

    if (authProvider.currentUser != null) {
      tripProvider.fetchTrips(authProvider.currentUser!.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.trips),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addTrip).then((_) {
                _loadTrips();
              });
            },
          ),
        ],
      ),
      body: Consumer<TripProvider>(
        builder: (context, tripProvider, child) {
          if (tripProvider.isLoading) {
            return const LoadingWidget();
          }

          if (tripProvider.trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    size: 80,
                    color: AppColors.grayText.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No trips yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grayText.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.addTrip)
                          .then((_) => _loadTrips());
                    },
                    child: const Text('Add your first trip'),
                  ),
                ],
              ),
            );
          }

          // Group trips by status
          final plannedTrips = tripProvider.getTripsByStatus('Planned');
          final completedTrips = tripProvider.getTripsByStatus('Completed');
          final cancelledTrips = tripProvider.getTripsByStatus('Cancelled');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (plannedTrips.isNotEmpty) ...[
                  const Text(
                    'Planned Trips',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...plannedTrips.map((trip) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TripCard(trip: trip),
                      )),
                  const SizedBox(height: 20),
                ],
                if (completedTrips.isNotEmpty) ...[
                  const Text(
                    'Completed Trips',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...completedTrips.map((trip) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TripCard(trip: trip),
                      )),
                  const SizedBox(height: 20),
                ],
                if (cancelledTrips.isNotEmpty) ...[
                  const Text(
                    'Cancelled Trips',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...cancelledTrips.map((trip) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TripCard(trip: trip),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
