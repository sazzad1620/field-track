import 'package:field_track/features/auth/data/models/user_model.dart';
import 'package:field_track/features/auth/domain/entities/user.dart';

class AuthSessionModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const AuthSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  User toEntity() => user.toEntity();
}
