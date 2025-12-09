import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'dart:math' as math;

/// Trip Route Map Widget
/// Displays a map with pickup and destination markers and a route between them
class TripRouteMapWidget extends StatefulWidget {
  final LatLng? pickupLocation;
  final LatLng? destinationLocation;
  final String? pickupAddress;
  final String? destinationAddress;
  final Color routeColor;
  final VoidCallback? onPickupTap;
  final VoidCallback? onDestinationTap;

  const TripRouteMapWidget({
    super.key,
    this.pickupLocation,
    this.destinationLocation,
    this.pickupAddress,
    this.destinationAddress,
    this.routeColor = AppColors.primaryBlue,
    this.onPickupTap,
    this.onDestinationTap,
  });

  @override
  State<TripRouteMapWidget> createState() => _TripRouteMapWidgetState();
}

class _TripRouteMapWidgetState extends State<TripRouteMapWidget> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _updateMapElements();
  }

  @override
  void didUpdateWidget(TripRouteMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pickupLocation != widget.pickupLocation ||
        oldWidget.destinationLocation != widget.destinationLocation ||
        oldWidget.routeColor != widget.routeColor) {
      _updateMapElements();
      _adjustCamera();
    }
  }

  void _updateMapElements() {
    _markers.clear();
    _polylines.clear();

    // Add pickup marker
    if (widget.pickupLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: widget.pickupLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(
            title: 'Pickup',
            snippet: widget.pickupAddress ?? '',
          ),
        ),
      );
    }

    // Add destination marker
    if (widget.destinationLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: widget.destinationLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: widget.destinationAddress ?? '',
          ),
        ),
      );
    }

    // Add route polyline
    if (widget.pickupLocation != null && widget.destinationLocation != null) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [widget.pickupLocation!, widget.destinationLocation!],
          color: widget.routeColor,
          width: 4,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _adjustCamera() {
    if (_mapController == null ||
        widget.pickupLocation == null ||
        widget.destinationLocation == null) {
      return;
    }

    // Calculate bounds
    double minLat = math.min(
      widget.pickupLocation!.latitude,
      widget.destinationLocation!.latitude,
    );
    double maxLat = math.max(
      widget.pickupLocation!.latitude,
      widget.destinationLocation!.latitude,
    );
    double minLng = math.min(
      widget.pickupLocation!.longitude,
      widget.destinationLocation!.longitude,
    );
    double maxLng = math.max(
      widget.pickupLocation!.longitude,
      widget.destinationLocation!.longitude,
    );

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  LatLng _getInitialPosition() {
    if (widget.pickupLocation != null) {
      return widget.pickupLocation!;
    }
    if (widget.destinationLocation != null) {
      return widget.destinationLocation!;
    }
    // Default to Riyadh, Saudi Arabia
    return const LatLng(24.7136, 46.6753);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _getInitialPosition(),
              zoom: 12,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              // Adjust camera after map is created
              Future.delayed(const Duration(milliseconds: 500), () {
                _adjustCamera();
              });
            },
          ),
          // Legend overlay
          if (widget.pickupLocation != null ||
              widget.destinationLocation != null)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.pickupLocation != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: Colors.green[700],
                          ),
                          const SizedBox(width: 6),
                          const Text('Pickup', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    if (widget.pickupLocation != null &&
                        widget.destinationLocation != null)
                      const SizedBox(height: 4),
                    if (widget.destinationLocation != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 12, color: Colors.red[700]),
                          const SizedBox(width: 6),
                          const Text(
                            'Destination',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          // Edit buttons overlay
          if (widget.onPickupTap != null || widget.onDestinationTap != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.onPickupTap != null)
                    FloatingActionButton.small(
                      heroTag: 'edit_pickup',
                      onPressed: widget.onPickupTap,
                      backgroundColor: Colors.green[700],
                      child: const Icon(Icons.edit_location, size: 20),
                    ),
                  if (widget.onPickupTap != null &&
                      widget.onDestinationTap != null)
                    const SizedBox(height: 8),
                  if (widget.onDestinationTap != null)
                    FloatingActionButton.small(
                      heroTag: 'edit_destination',
                      onPressed: widget.onDestinationTap,
                      backgroundColor: Colors.red[700],
                      child: const Icon(Icons.edit_location, size: 20),
                    ),
                ],
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
