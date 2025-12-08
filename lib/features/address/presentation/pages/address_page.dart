import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/widgets/custom_button.dart';
import 'package:rattib/core/widgets/loading_widget.dart';
import 'package:rattib/core/utils/helpers.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/address/presentation/providers/address_provider.dart';

/// Address Page
/// Manage saved addresses
class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final List<String> _addressTypes = [
    AppStrings.homeAddress,
    AppStrings.work,
    AppStrings.restaurants,
    AppStrings.grocery,
    AppStrings.shopping,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAddresses();
    });
  }

  void _loadAddresses() {
    final authProvider = context.read<AuthProvider>();
    final addressProvider = context.read<AddressProvider>();

    if (authProvider.currentUser != null) {
      addressProvider.fetchAddresses(authProvider.currentUser!.userId);
    }
  }

  void _showAddAddressDialog(String addressType) {
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $addressType Address'),
        content: TextField(
          controller: addressController,
          decoration: const InputDecoration(
            hintText: 'Enter address',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (addressController.text.isNotEmpty) {
                final authProvider = context.read<AuthProvider>();
                final addressProvider = context.read<AddressProvider>();

                Navigator.pop(context);

                final success = await addressProvider.createAddress(
                  userId: authProvider.currentUser!.userId,
                  addressType: addressType,
                  addressLine: addressController.text,
                );

                if (mounted) {
                  if (success) {
                    Helpers.showSuccess(context, 'Address added successfully');
                  } else {
                    Helpers.showError(
                      context,
                      addressProvider.errorMessage ?? 'Failed to add address',
                    );
                  }
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteAddress(int addressId) {
    Helpers.showConfirmDialog(
      context,
      title: 'Delete Address',
      message: 'Are you sure you want to delete this address?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    ).then((confirmed) async {
      if (confirmed) {
        final authProvider = context.read<AuthProvider>();
        final addressProvider = context.read<AddressProvider>();

        final success = await addressProvider.deleteAddress(
          addressId,
          authProvider.currentUser!.userId,
        );

        if (mounted) {
          if (success) {
            Helpers.showSuccess(context, 'Address deleted successfully');
          } else {
            Helpers.showError(
              context,
              addressProvider.errorMessage ?? 'Failed to delete address',
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Addresses'),
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          if (addressProvider.isLoading) {
            return const LoadingWidget();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Edit Account Info Button
                CustomButton(
                  text: AppStrings.editAccountInfo,
                  onPressed: () {
                    Helpers.showSnackBar(
                      context,
                      'Edit account feature coming soon',
                    );
                  },
                  isOutlined: true,
                ),
                const SizedBox(height: 24),
                // Address type cards
                ..._addressTypes.map((type) {
                  final addressesForType = addressProvider.addresses
                      .where((addr) => addr.addressType == type)
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _AddressTypeCard(
                      addressType: type,
                      addresses: addressesForType,
                      onAdd: () => _showAddAddressDialog(type),
                      onDelete: _deleteAddress,
                    ),
                  );
                }),
                const SizedBox(height: 24),
                // Save Button
                CustomButton(
                  text: AppStrings.save,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AddressTypeCard extends StatelessWidget {
  final String addressType;
  final List addresses;
  final VoidCallback onAdd;
  final Function(int) onDelete;

  const _AddressTypeCard({
    required this.addressType,
    required this.addresses,
    required this.onAdd,
    required this.onDelete,
  });

  IconData _getIconForType(String type) {
    switch (type) {
      case AppStrings.homeAddress:
        return Icons.home;
      case AppStrings.work:
        return Icons.work;
      case AppStrings.restaurants:
        return Icons.restaurant;
      case AppStrings.grocery:
        return Icons.shopping_cart;
      case AppStrings.shopping:
        return Icons.shopping_bag;
      default:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconForType(addressType),
                color: AppColors.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  addressType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.primaryBlue,
                onPressed: onAdd,
              ),
            ],
          ),
          if (addresses.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...addresses.map((address) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 36),
                      Expanded(
                        child: Text(
                          address.addressLine,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.grayText,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        iconSize: 20,
                        onPressed: () => onDelete(address.addressId),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
