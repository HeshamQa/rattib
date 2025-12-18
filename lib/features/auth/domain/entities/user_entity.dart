import 'package:equatable/equatable.dart';

/// User Entity
/// Domain layer representation of a user
class UserEntity extends Equatable {
  final int userId;
  final String name;
  final String email;
  final bool isAdmin;
  final int? adminId;
  final String? role;

  const UserEntity({
    required this.userId,
    required this.name,
    required this.email,
    this.isAdmin = false,
    this.adminId,
    this.role,
  });

  @override
  List<Object?> get props => [userId, name, email, isAdmin, adminId, role];
}
