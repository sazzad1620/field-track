import 'package:dio/dio.dart';
import 'package:field_track/core/network/auth_interceptor.dart';
import 'package:field_track/core/network/dio_client.dart';
import 'package:field_track/core/router/app_router.dart';
import 'package:field_track/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:field_track/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:field_track/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:field_track/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final sl = GetIt.instance;

Future<void> setupInjection() async {
  if (!sl.isRegistered<FlutterSecureStorage>()) {
    sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
  }

  if (!sl.isRegistered<AuthLocalDatasource>()) {
    sl.registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasource(sl()),
    );
  }

  if (!sl.isRegistered<Dio>()) {
    final dio = createDio();
    dio.interceptors.add(AuthInterceptor(local: sl(), dio: dio));
    sl.registerLazySingleton<Dio>(() => dio);
  }

  if (!sl.isRegistered<AuthRemoteDatasource>()) {
    sl.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasource(sl()),
    );
  }

  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: sl(), local: sl()),
    );
  }

  if (!sl.isRegistered<GoRouter>()) {
    sl.registerLazySingleton<GoRouter>(createAppRouter);
  }
}
