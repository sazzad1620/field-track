import 'package:field_track/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:field_track/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:field_track/features/auth/data/models/auth_session_model.dart';
import 'package:field_track/features/auth/domain/entities/user.dart';
import 'package:field_track/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;
  final AuthLocalDatasource local;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<User> login({required String email, required String password}) async {
    final session = await remote.login(email: email, password: password);
    await _saveSession(session);
    return session.toEntity();
  }

  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final session = await remote.register(
      fullName: fullName,
      email: email,
      password: password,
    );
    await _saveSession(session);
    return session.toEntity();
  }

  @override
  Future<User> getCurrentUser() async {
    return (await remote.getCurrentUser()).toEntity();
  }

  @override
  Future<void> logout() async {
    try {
      await remote.logout();
    } finally {
      await local.clearTokens();
    }
  }

  @override
  Future<bool> validateSession() async {
    if (!await local.hasSession()) return false;

    try {
      await getCurrentUser();
      return true;
    } catch (_) {
      await local.clearTokens();
      return false;
    }
  }

  Future<void> _saveSession(AuthSessionModel session) async {
    await local.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
  }
}
