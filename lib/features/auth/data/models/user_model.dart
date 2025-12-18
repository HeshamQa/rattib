import 'package:rattib/features/auth/domain/entities/user_entity.dart';

/// User Model
/// Data layer representation of a user
class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.name,
    required super.email,
    super.isAdmin = false,
    super.adminId,
    super.role,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userId = json['user_id'];
    return UserModel(
      userId: userId is int ? userId : int.parse(userId.toString()),
      name: json['name'] as String,
      email: json['email'] as String,
      isAdmin: json['is_admin'] == true,
      adminId: json['admin_id'] != null
          ? (json['admin_id'] is int ? json['admin_id'] : int.parse(json['admin_id'].toString()))
          : null,
      role: json['role'] as String?,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'is_admin': isAdmin,
      'admin_id': adminId,
      'role': role,
    };
  }

  /// Convert to entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
      isAdmin: isAdmin,
      adminId: adminId,
      role: role,
    );
  }
}
