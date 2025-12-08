/// Trip Model
/// Data layer representation of a trip
class TripModel {
  final int tripId;
  final String destination;
  final String startDate;
  final String? endDate;
  final String status;
  final String? createdAt;

  const TripModel({
    required this.tripId,
    required this.destination,
    required this.startDate,
    this.endDate,
    required this.status,
    this.createdAt,
  });

  /// Create TripModel from JSON
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      tripId: json['trip_id'] as int,
      destination: json['destination'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String?,
      status: json['status'] as String? ?? 'Planned',
      createdAt: json['created_at'] as String?,
    );
  }

  /// Convert TripModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'trip_id': tripId,
      'destination': destination,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'created_at': createdAt,
    };
  }
}
