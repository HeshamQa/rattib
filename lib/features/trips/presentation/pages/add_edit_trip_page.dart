import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/widgets/custom_button.dart';
import 'package:rattib/core/widgets/custom_text_field.dart';
import 'package:rattib/core/utils/validators.dart';
import 'package:rattib/core/utils/helpers.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/trips/data/models/trip_model.dart';
import 'package:rattib/features/trips/presentation/providers/trip_provider.dart';

/// Add/Edit Trip Page
/// Create or update a trip
class AddEditTripPage extends StatefulWidget {
  final TripModel? trip;

  const AddEditTripPage({
    super.key,
    this.trip,
  });

  @override
  State<AddEditTripPage> createState() => _AddEditTripPageState();
}

class _AddEditTripPageState extends State<AddEditTripPage> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  String _selectedStatus = 'Planned';
  final List<String> _statusOptions = ['Planned', 'Completed', 'Cancelled'];

  bool get isEditMode => widget.trip != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _destinationController.text = widget.trip!.destination;
      _startDateController.text = widget.trip!.startDate;
      _endDateController.text = widget.trip!.endDate ?? '';
      _selectedStatus = widget.trip!.status;
    }
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _startDateController.text = Helpers.formatDate(picked);
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _endDateController.text = Helpers.formatDate(picked);
      });
    }
  }

  Future<void> _saveTrip() async {
    if (_formKey.currentState!.validate()) {
      Helpers.dismissKeyboard(context);

      final authProvider = context.read<AuthProvider>();
      final tripProvider = context.read<TripProvider>();

      bool success;

      if (isEditMode) {
        success = await tripProvider.updateTrip(
          tripId: widget.trip!.tripId,
          userId: authProvider.currentUser!.userId,
          destination: _destinationController.text.trim(),
          startDate: _startDateController.text.trim(),
          endDate: _endDateController.text.trim().isNotEmpty
              ? _endDateController.text.trim()
              : null,
          status: _selectedStatus,
        );
      } else {
        success = await tripProvider.createTrip(
          userId: authProvider.currentUser!.userId,
          destination: _destinationController.text.trim(),
          startDate: _startDateController.text.trim(),
          endDate: _endDateController.text.trim().isNotEmpty
              ? _endDateController.text.trim()
              : null,
          status: _selectedStatus,
        );
      }

      if (!mounted) return;

      if (success) {
        Helpers.showSuccess(
          context,
          isEditMode ? 'Trip updated successfully' : 'Trip created successfully',
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
                // Destination Field
                CustomTextField(
                  controller: _destinationController,
                  labelText: AppStrings.destination,
                  hintText: 'Enter destination',
                  prefixIcon: const Icon(Icons.location_city),
                  validator: (value) =>
                      Validators.validateRequired(value, fieldName: 'Destination'),
                ),
                const SizedBox(height: 16),
                // Start Date Field
                CustomTextField(
                  controller: _startDateController,
                  labelText: AppStrings.startDate,
                  hintText: 'Select start date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  readOnly: true,
                  onTap: _selectStartDate,
                  validator: (value) =>
                      Validators.validateRequired(value, fieldName: 'Start date'),
                ),
                const SizedBox(height: 16),
                // End Date Field
                CustomTextField(
                  controller: _endDateController,
                  labelText: AppStrings.endDate,
                  hintText: 'Select end date (optional)',
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  readOnly: true,
                  onTap: _selectEndDate,
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
                      borderSide: const BorderSide(color: AppColors.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.borderColor),
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
