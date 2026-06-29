import 'package:dio/dio.dart';
import 'package:field_track/core/constants/api_constants.dart';
import 'package:field_track/features/auth/data/models/auth_session_model.dart';
import 'package:field_track/features/auth/data/models/user_model.dart';

class AuthRemoteDatasource {
  final Dio dio;
  final Dio _plainDio;

  AuthRemoteDatasource(this.dio) : _plainDio = Dio(dio.options);

  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return AuthSessionModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthSessionModel> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'full_name': fullName,
      },
    );
    return AuthSessionModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> getCurrentUser() async {
    final response = await dio.get(ApiConstants.me);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await dio.post(ApiConstants.logout);
  }

  Future<AuthSessionModel> refresh(String refreshToken) async {
    final response = await _plainDio.post(
      ApiConstants.refresh,
      data: {'refresh_token': refreshToken},
    );
    return AuthSessionModel.fromJson(response.data as Map<String, dynamic>);
  }
}
