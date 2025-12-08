/// Address Model
/// Data layer representation of an address
class AddressModel {
  final int addressId;
  final String addressType;
  final String addressLine;
  final double? latitude;
  final double? longitude;
  final String? createdAt;

  const AddressModel({
    required this.addressId,
    required this.addressType,
    required this.addressLine,
    this.latitude,
    this.longitude,
    this.createdAt,
  });

  /// Create AddressModel from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'] is int
          ? json['address_id'] as int
          : int.parse(json['address_id'].toString()),
      addressType: json['address_type'] as String,
      addressLine: json['address_line'] as String,
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      createdAt: json['created_at'] as String?,
    );
  }

  /// Convert AddressModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'address_type': addressType,
      'address_line': addressLine,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
    };
  }
}
