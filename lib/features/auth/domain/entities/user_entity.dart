import 'package:equatable/equatable.dart';

/// User Entity
/// Domain layer representation of a user
class UserEntity extends Equatable {
  final int userId;
  final String name;
  final String email;

  const UserEntity({
    required this.userId,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [userId, name, email];
}
