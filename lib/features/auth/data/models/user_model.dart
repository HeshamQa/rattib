import 'package:rattib/features/auth/domain/entities/user_entity.dart';

/// User Model
/// Data layer representation of a user
class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.name,
    required super.email,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
    };
  }

  /// Convert to entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
    );
  }
}
