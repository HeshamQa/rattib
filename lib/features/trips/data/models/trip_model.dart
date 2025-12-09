/// Trip Model
/// Data layer representation of a trip
class TripModel {
  final int tripId;
  final String destination;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final String? pickupLocation;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? tripDate;
  final String status;
  final String? createdAt;
  final int? order; // For optimized route ordering

  const TripModel({
    required this.tripId,
    required this.destination,
    this.destinationLatitude,
    this.destinationLongitude,
    this.pickupLocation,
    this.pickupLatitude,
    this.pickupLongitude,
    this.tripDate,
    required this.status,
    this.createdAt,
    this.order,
  });

  /// Create TripModel from JSON
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      tripId: json['trip_id'] is int
          ? json['trip_id'] as int
          : int.parse(json['trip_id'].toString()),
      destination: json['destination'] as String,
      destinationLatitude: json['destination_latitude'] != null
          ? _parseDouble(json['destination_latitude'])
          : null,
      destinationLongitude: json['destination_longitude'] != null
          ? _parseDouble(json['destination_longitude'])
          : null,
      pickupLocation: json['pickup_location'] as String?,
      pickupLatitude: json['pickup_latitude'] != null
          ? _parseDouble(json['pickup_latitude'])
          : null,
      pickupLongitude: json['pickup_longitude'] != null
          ? _parseDouble(json['pickup_longitude'])
          : null,
      tripDate: json['trip_date'] as String?,
      status: json['status'] as String? ?? 'Planned',
      createdAt: json['created_at'] as String?,
      order: json['order'] as int?,
    );
  }

  /// Helper to parse double values
  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }

  /// Convert TripModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'trip_id': tripId,
      'destination': destination,
      if (destinationLatitude != null)
        'destination_latitude': destinationLatitude,
      if (destinationLongitude != null)
        'destination_longitude': destinationLongitude,
      if (pickupLocation != null) 'pickup_location': pickupLocation,
      if (pickupLatitude != null) 'pickup_latitude': pickupLatitude,
      if (pickupLongitude != null) 'pickup_longitude': pickupLongitude,
      if (tripDate != null) 'trip_date': tripDate,
      'status': status,
      'created_at': createdAt,
      if (order != null) 'order': order,
    };
  }
}
