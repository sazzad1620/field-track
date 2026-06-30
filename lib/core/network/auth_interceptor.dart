import 'dart:async';

import 'package:dio/dio.dart';
import 'package:field_track/core/constants/api_constants.dart';
import 'package:field_track/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:field_track/features/auth/data/models/auth_session_model.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this._local,
    required this._dio,
  }) {
    _refreshDio = Dio(_dio.options);
  }

  final AuthLocalDatasource _local;
  final Dio _dio;
  late final Dio _refreshDio;

  Completer<String?>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _local.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 || _isAuthPath(err.requestOptions.path)) {
      handler.next(err);
      return;
    }

    try {
      final newToken = await _refreshAccessToken();
      if (newToken == null) {
        handler.next(err);
        return;
      }

      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final response = await _dio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    }
  }

  bool _isAuthPath(String path) {
    return path.contains(ApiConstants.login) ||
        path.contains(ApiConstants.refresh);
  }

  Future<String?> _refreshAccessToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();
    try {
      final refreshToken = await _local.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _refreshCompleter!.complete(null);
        return null;
      }

      final response = await _refreshDio.post(
        ApiConstants.refresh,
        data: {'refresh_token': refreshToken},
      );
      final session = AuthSessionModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      await _local.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      _refreshCompleter!.complete(session.accessToken);
      return session.accessToken;
    } catch (_) {
      await _local.clearTokens();
      _refreshCompleter!.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }
}
