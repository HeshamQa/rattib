import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/tasks/presentation/providers/task_provider.dart';
import 'package:rattib/features/trips/presentation/providers/trip_provider.dart';

/// Map Page
/// Display tasks and trips on Google Maps
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _isLoading = true;

  /// Generate a unique color for each trip route
  Color _getRouteColor(
    int tripId,
    double? pickupLat,
    double? pickupLng,
    double? destLat,
    double? destLng,
  ) {
    // Generate a consistent color based on trip ID and coordinates
    final String colorSeed =
        '${tripId}_${pickupLat ?? 0}_${pickupLng ?? 0}_${destLat ?? 0}_${destLng ?? 0}';
    final int hash = colorSeed.hashCode;

    // Generate HSL color with good saturation and lightness for visibility
    final double hue = (hash % 360).toDouble();
    final Color color = HSLColor.fromAHSL(1.0, hue, 0.7, 0.5).toColor();

    return color;
  }

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation();
    await _loadTasksAndTrips();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Use default location if permission denied
        _currentPosition = Position(
          latitude: 24.7136,
          longitude: 46.6753,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      // Use default location (Riyadh, Saudi Arabia)
      _currentPosition = Position(
        latitude: 24.7136,
        longitude: 46.6753,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
  }

  Future<void> _loadTasksAndTrips() async {
    final authProvider = context.read<AuthProvider>();
    final taskProvider = context.read<TaskProvider>();
    final tripProvider = context.read<TripProvider>();

    if (authProvider.currentUser != null) {
      await taskProvider.fetchTasks(authProvider.currentUser!.userId);
      await tripProvider.fetchTrips(authProvider.currentUser!.userId);
    }

    _buildMarkersAndRoutes();
  }

  void _buildMarkersAndRoutes() {
    _markers.clear();
    _polylines.clear();

    // Add current location marker
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    }

    // Add task markers
    final taskProvider = context.read<TaskProvider>();
    for (var task in taskProvider.tasks) {
      if (task.latitude != null && task.longitude != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('task_${task.taskId}'),
            position: LatLng(task.latitude!, task.longitude!),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              task.status == 'Completed'
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueOrange,
            ),
            infoWindow: InfoWindow(title: task.title, snippet: task.location),
          ),
        );
      }
    }

    // Add trip markers and routes
    final tripProvider = context.read<TripProvider>();
    for (var trip in tripProvider.trips) {
      // Only show trips that have both pickup and destination coordinates
      if (trip.pickupLatitude != null &&
          trip.pickupLongitude != null &&
          trip.destinationLatitude != null &&
          trip.destinationLongitude != null) {
        final pickupLocation = LatLng(
          trip.pickupLatitude!,
          trip.pickupLongitude!,
        );
        final destinationLocation = LatLng(
          trip.destinationLatitude!,
          trip.destinationLongitude!,
        );
        final routeColor = _getRouteColor(
          trip.tripId,
          trip.pickupLatitude,
          trip.pickupLongitude,
          trip.destinationLatitude,
          trip.destinationLongitude,
        );

        // Add pickup marker (green)
        _markers.add(
          Marker(
            markerId: MarkerId('trip_pickup_${trip.tripId}'),
            position: pickupLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            infoWindow: InfoWindow(
              title: '🚗 Pickup: ${trip.destination}',
              snippet: trip.pickupLocation ?? 'Pickup location',
            ),
          ),
        );

        // Add destination marker (red)
        _markers.add(
          Marker(
            markerId: MarkerId('trip_dest_${trip.tripId}'),
            position: destinationLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(
              title: '📍 ${trip.destination}',
              snippet: 'Status: ${trip.status}',
            ),
          ),
        );

        // Add route polyline with unique color
        _polylines.add(
          Polyline(
            polylineId: PolylineId('trip_route_${trip.tripId}'),
            points: [pickupLocation, destinationLocation],
            color: routeColor,
            width: 4,
            patterns: [PatternItem.dash(20), PatternItem.gap(10)],
          ),
        );
      }
    }
  }

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              if (_currentPosition != null && _mapController != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    14,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            )
          : _currentPosition == null
          ? const Center(child: Text('Unable to get location'))
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    zoom: 14,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                ),
                // Legend overlay
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Legend',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildLegendItem(
                          Icons.circle,
                          Colors.blue,
                          'Your Location',
                        ),
                        const SizedBox(height: 4),
                        _buildLegendItem(
                          Icons.circle,
                          Colors.green,
                          'Trip Pickup',
                        ),
                        const SizedBox(height: 4),
                        _buildLegendItem(
                          Icons.circle,
                          Colors.red,
                          'Trip Destination',
                        ),
                        const SizedBox(height: 4),
                        _buildLegendItem(
                          Icons.circle,
                          Colors.orange,
                          'Pending Task',
                        ),
                        const SizedBox(height: 4),
                        _buildLegendItem(
                          Icons.circle,
                          Colors.green[700]!,
                          'Completed Task',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple,
                                    Colors.blue,
                                    Colors.orange,
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Trip Routes',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
