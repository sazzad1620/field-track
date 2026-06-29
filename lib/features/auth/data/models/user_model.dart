import 'package:field_track/features/auth/domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }

  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        role: role,
      );
}
