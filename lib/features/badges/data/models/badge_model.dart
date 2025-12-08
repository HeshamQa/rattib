/// Badge Model
/// Data layer representation of a badge
class BadgeModel {
  final int badgeId;
  final String badgeName;
  final String description;
  final String? iconUrl;
  final String criteria;
  final String? earnedAt;

  const BadgeModel({
    required this.badgeId,
    required this.badgeName,
    required this.description,
    this.iconUrl,
    required this.criteria,
    this.earnedAt,
  });

  /// Create BadgeModel from JSON
  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      badgeId: json['badge_id'] as int,
      badgeName: json['badge_name'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String?,
      criteria: json['criteria'] as String,
      earnedAt: json['earned_at'] as String?,
    );
  }

  /// Convert BadgeModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'badge_id': badgeId,
      'badge_name': badgeName,
      'description': description,
      'icon_url': iconUrl,
      'criteria': criteria,
      'earned_at': earnedAt,
    };
  }
}
