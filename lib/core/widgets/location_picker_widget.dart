import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/widgets/custom_button.dart';

/// Location Picker Widget
/// Allows users to pick a location from Google Maps
class LocationPickerWidget extends StatefulWidget {
  final LatLng? initialLocation;
  final String? initialAddress;

  const LocationPickerWidget({
    super.key,
    this.initialLocation,
    this.initialAddress,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _selectedAddress;
  bool _isLoading = true;
  bool _isGettingAddress = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _selectedAddress = widget.initialAddress;
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Get current location
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Use default location (Riyadh, Saudi Arabia)
        _selectedLocation = const LatLng(24.7136, 46.6753);
      } else {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _selectedLocation = LatLng(position.latitude, position.longitude);
      }
    } catch (e) {
      // Use default location (Riyadh, Saudi Arabia)
      _selectedLocation = const LatLng(24.7136, 46.6753);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() {
      _isGettingAddress = true;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        _selectedAddress = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      }
    } catch (e) {
      _selectedAddress = '${position.latitude}, ${position.longitude}';
    }

    setState(() {
      _isGettingAddress = false;
    });
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
    _getAddressFromLatLng(position);
  }

  void _onConfirm() {
    if (_selectedLocation != null) {
      Navigator.pop(context, {
        'location': _selectedAddress ?? '${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      });
    }
  }
  final TextEditingController _searchController = TextEditingController();
  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    try {
      final locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        final loc = locations.first;
        final target = LatLng(loc.latitude, loc.longitude);

        // حرّك الماب
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(target, 15),
        );

        // عدّل الموقع المختار
        _onMapTap(target);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () async {
                try {
                  final position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );
                  final newLocation = LatLng(position.latitude, position.longitude);
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(newLocation, 14),
                  );
                  _onMapTap(newLocation);
                } catch (e) {
                  // Handle error silently
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlue,
              ),
            )
          : Stack(
              children: [

                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation ?? const LatLng(24.7136, 46.6753),
                    zoom: 14,
                  ),
                  markers: _selectedLocation != null
                      ? {
                          Marker(
                            markerId: const MarkerId('selected_location'),
                            position: _selectedLocation!,
                            draggable: true,
                            onDragEnd: (newPosition) {
                              _onMapTap(newPosition);
                            },
                          ),
                        }
                      : {},
                  onTap: _onMapTap,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: "Search location...",
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _searchLocation(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _searchLocation,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_selectedAddress != null)
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedAddress!,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Loading indicator for address
                if (_isGettingAddress)
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('Getting address...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Confirm button at bottom
                if (_selectedLocation != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: CustomButton(
                      text: 'Confirm Location',
                      onPressed: _onConfirm,
                      isLoading: false,
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
