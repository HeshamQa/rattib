import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/widgets/custom_button.dart';
import 'package:rattib/core/widgets/custom_text_field.dart';
import 'package:rattib/core/widgets/location_picker_widget.dart';
import 'package:rattib/core/widgets/trip_route_map_widget.dart';
import 'package:rattib/core/utils/validators.dart';
import 'package:rattib/core/utils/helpers.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/trips/data/models/trip_model.dart';
import 'package:rattib/features/trips/presentation/providers/trip_provider.dart';

/// Add/Edit Trip Page
/// Create or update a trip with location selection
class AddEditTripPage extends StatefulWidget {
  final TripModel? trip;

  const AddEditTripPage({super.key, this.trip});

  @override
  State<AddEditTripPage> createState() => _AddEditTripPageState();
}

class _AddEditTripPageState extends State<AddEditTripPage> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _pickupLocationController = TextEditingController();
  final _tripDateController = TextEditingController();

  // Location data
  double? _pickupLatitude;
  double? _pickupLongitude;
  double? _destinationLatitude;
  double? _destinationLongitude;

  String _selectedStatus = 'Planned';
  final List<String> _statusOptions = ['Planned', 'Completed', 'Cancelled'];

  bool get isEditMode => widget.trip != null;

  /// Generate a unique color for the route based on trip data
  Color _getRouteColor() {
    // Generate a consistent color based on the trip's pickup and destination
    final String colorSeed =
        '${_pickupLatitude ?? 0}_${_pickupLongitude ?? 0}_${_destinationLatitude ?? 0}_${_destinationLongitude ?? 0}';
    final int hash = colorSeed.hashCode;

    // Generate HSL color with good saturation and lightness for visibility
    final double hue = (hash % 360).toDouble();
    final Color color = HSLColor.fromAHSL(1.0, hue, 0.7, 0.5).toColor();

    return color;
  }

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _destinationController.text = widget.trip!.destination;
      _pickupLocationController.text = widget.trip!.pickupLocation ?? '';
      _tripDateController.text = widget.trip!.tripDate ?? '';
      _selectedStatus = widget.trip!.status;
      _pickupLatitude = widget.trip!.pickupLatitude;
      _pickupLongitude = widget.trip!.pickupLongitude;
      _destinationLatitude = widget.trip!.destinationLatitude;
      _destinationLongitude = widget.trip!.destinationLongitude;
    }
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _pickupLocationController.dispose();
    _tripDateController.dispose();
    super.dispose();
  }

  Future<void> _selectTripDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _tripDateController.text = Helpers.formatDate(picked);
      });
    }
  }

  Future<void> _selectPickupLocation() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerWidget(
          initialLocation: _pickupLatitude != null && _pickupLongitude != null
              ? LatLng(_pickupLatitude!, _pickupLongitude!)
              : null,
          initialAddress: _pickupLocationController.text.isNotEmpty
              ? _pickupLocationController.text
              : null,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _pickupLocationController.text = result['location'] as String;
        _pickupLatitude = result['latitude'] as double;
        _pickupLongitude = result['longitude'] as double;
      });
    }
  }

  Future<void> _selectDestinationLocation() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerWidget(
          initialLocation:
              _destinationLatitude != null && _destinationLongitude != null
              ? LatLng(_destinationLatitude!, _destinationLongitude!)
              : null,
          initialAddress: _destinationController.text.isNotEmpty
              ? _destinationController.text
              : null,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _destinationController.text = result['location'] as String;
        _destinationLatitude = result['latitude'] as double;
        _destinationLongitude = result['longitude'] as double;
      });
    }
  }

  Future<void> _saveTrip() async {
    if (_formKey.currentState!.validate()) {
      // Validate location selections
      if (_pickupLatitude == null || _pickupLongitude == null) {
        Helpers.showError(context, 'Please select a pickup location');
        return;
      }

      if (_destinationLatitude == null || _destinationLongitude == null) {
        Helpers.showError(context, 'Please select a destination location');
        return;
      }

      Helpers.dismissKeyboard(context);

      final authProvider = context.read<AuthProvider>();
      final tripProvider = context.read<TripProvider>();

      bool success;

      if (isEditMode) {
        success = await tripProvider.updateTrip(
          tripId: widget.trip!.tripId,
          userId: authProvider.currentUser!.userId,
          destination: _destinationController.text.trim(),
          destinationLatitude: _destinationLatitude!,
          destinationLongitude: _destinationLongitude!,
          pickupLocation: _pickupLocationController.text.trim(),
          pickupLatitude: _pickupLatitude!,
          pickupLongitude: _pickupLongitude!,
          tripDate: _tripDateController.text.trim(),
          status: _selectedStatus,
        );
      } else {
        success = await tripProvider.createTrip(
          userId: authProvider.currentUser!.userId,
          destination: _destinationController.text.trim(),
          destinationLatitude: _destinationLatitude!,
          destinationLongitude: _destinationLongitude!,
          pickupLocation: _pickupLocationController.text.trim(),
          pickupLatitude: _pickupLatitude!,
          pickupLongitude: _pickupLongitude!,
          tripDate: _tripDateController.text.trim(),
          status: _selectedStatus,
        );
      }

      if (!mounted) return;

      if (success) {
        Helpers.showSuccess(
          context,
          isEditMode
              ? 'Trip updated successfully'
              : 'Trip created successfully',
        );
        Navigator.pop(context);
      } else {
        Helpers.showError(
          context,
          tripProvider.errorMessage ?? 'Failed to save trip',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(isEditMode ? AppStrings.editTrip : AppStrings.addTrip),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Route Map Preview
                if (_pickupLatitude != null && _pickupLongitude != null ||
                    _destinationLatitude != null &&
                        _destinationLongitude != null) ...[
                  const Text(
                    'Route Preview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TripRouteMapWidget(
                    pickupLocation:
                        _pickupLatitude != null && _pickupLongitude != null
                        ? LatLng(_pickupLatitude!, _pickupLongitude!)
                        : null,
                    destinationLocation:
                        _destinationLatitude != null &&
                            _destinationLongitude != null
                        ? LatLng(_destinationLatitude!, _destinationLongitude!)
                        : null,
                    pickupAddress: _pickupLocationController.text,
                    destinationAddress: _destinationController.text,
                    routeColor: _getRouteColor(),
                    onPickupTap: _selectPickupLocation,
                    onDestinationTap: _selectDestinationLocation,
                  ),
                  const SizedBox(height: 20),
                ],
                // Pickup Location Field
                CustomTextField(
                  controller: _pickupLocationController,
                  labelText: 'Pickup Location',
                  hintText: 'Select pickup location from map',
                  prefixIcon: const Icon(Icons.my_location),
                  readOnly: true,
                  onTap: _selectPickupLocation,
                  validator: (value) => Validators.validateRequired(
                    value,
                    fieldName: 'Pickup location',
                  ),
                ),
                const SizedBox(height: 16),
                // Destination Field
                CustomTextField(
                  controller: _destinationController,
                  labelText: AppStrings.destination,
                  hintText: 'Select destination from map',
                  prefixIcon: const Icon(Icons.location_on),
                  readOnly: true,
                  onTap: _selectDestinationLocation,
                  validator: (value) => Validators.validateRequired(
                    value,
                    fieldName: 'Destination',
                  ),
                ),
                const SizedBox(height: 16),
                // Trip Date Field
                CustomTextField(
                  controller: _tripDateController,
                  labelText: 'Trip Date',
                  hintText: 'Select trip date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  readOnly: true,
                  onTap: _selectTripDate,
                  validator: (value) => Validators.validateRequired(
                    value,
                    fieldName: 'Trip date',
                  ),
                ),
                const SizedBox(height: 16),
                // Status Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: AppStrings.status,
                    prefixIcon: const Icon(Icons.info_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.focusedBorderColor,
                        width: 2,
                      ),
                    ),
                  ),
                  items: _statusOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 32),
                // Save Button
                Consumer<TripProvider>(
                  builder: (context, tripProvider, child) {
                    return CustomButton(
                      text: isEditMode ? AppStrings.save : AppStrings.addTrip,
                      onPressed: _saveTrip,
                      isLoading: tripProvider.isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
