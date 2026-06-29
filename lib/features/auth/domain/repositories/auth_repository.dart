import 'package:field_track/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});

  Future<User> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<User> getCurrentUser();

  Future<void> logout();

  Future<bool> validateSession();
}
