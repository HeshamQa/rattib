import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/routes/app_routes.dart';
import 'package:rattib/core/utils/helpers.dart';
import 'package:rattib/core/widgets/loading_widget.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/trips/data/models/trip_model.dart';
import 'package:rattib/features/trips/presentation/providers/trip_provider.dart';
import 'package:rattib/features/trips/presentation/widgets/trip_card.dart';

/// Trips Page
/// View and manage trips with route optimization
class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  List<TripModel>? _optimizedTrips;
  bool _showOptimized = false;

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

    // Reset optimization view when reloading
    setState(() {
      _showOptimized = false;
      _optimizedTrips = null;
    });
  }

  Future<void> _optimizeRoute() async {
    final authProvider = context.read<AuthProvider>();
    final tripProvider = context.read<TripProvider>();

    if (authProvider.currentUser == null) return;

    final optimized = await tripProvider.optimizeRoute(
      authProvider.currentUser!.userId,
    );

    if (!mounted) return;

    if (optimized.isNotEmpty) {
      setState(() {
        _optimizedTrips = optimized;
        _showOptimized = true;
      });
      Helpers.showSuccess(
        context,
        'Route optimized! Showing ${optimized.length} trips in optimal order',
      );
    } else {
      Helpers.showError(
        context,
        tripProvider.errorMessage ?? 'No planned trips to optimize',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(_showOptimized ? 'Optimized Route' : AppStrings.trips),
        actions: [
          if (_showOptimized)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Clear optimization',
              onPressed: () {
                setState(() {
                  _showOptimized = false;
                  _optimizedTrips = null;
                });
              },
            ),
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
          if (tripProvider.isLoading && !_showOptimized) {
            return const LoadingWidget();
          }

          // Show optimized trips if available
          if (_showOptimized && _optimizedTrips != null) {
            return _buildOptimizedTripsList(_optimizedTrips!);
          }

          // Show regular trips list
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
                      Navigator.pushNamed(
                        context,
                        AppRoutes.addTrip,
                      ).then((_) => _loadTrips());
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Planned Trips',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      Text(
                        '${plannedTrips.length} trips',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.grayText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...plannedTrips.map(
                    (trip) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TripCard(trip: trip),
                    ),
                  ),
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
                  ...completedTrips.map(
                    (trip) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TripCard(trip: trip),
                    ),
                  ),
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
                  ...cancelledTrips.map(
                    (trip) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TripCard(trip: trip),
                    ),
                  ),
                ],
                // Add bottom padding for FAB
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Consumer<TripProvider>(
        builder: (context, tripProvider, child) {
          final plannedTrips = tripProvider.getTripsByStatus('Planned');

          // Only show FAB if there are planned trips
          if (plannedTrips.isEmpty || _showOptimized) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton.extended(
            onPressed: tripProvider.isLoading ? null : _optimizeRoute,
            backgroundColor: AppColors.primaryBlue,
            icon: const Icon(Icons.route, color: Colors.white),
            label: const Text(
              'Optimize Route',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptimizedTripsList(List<TripModel> trips) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Trips are ordered for optimal route based on locations. Follow the order numbers for the most efficient journey.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Optimized Trip Order',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 12),
          ...trips.map(
            (trip) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TripCard(trip: trip),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
