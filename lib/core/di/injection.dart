import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:field_track/core/network/auth_interceptor.dart';
import 'package:field_track/core/network/dio_client.dart';
import 'package:field_track/core/router/app_router.dart';
import 'package:field_track/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:field_track/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:field_track/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:field_track/features/auth/domain/repositories/auth_repository.dart';
import 'package:field_track/features/geofence/domain/geofence_registry.dart';
import 'package:field_track/features/locations/data/datasources/location_local_datasource.dart';
import 'package:field_track/features/locations/data/datasources/location_remote_datasource.dart';
import 'package:field_track/features/locations/data/repositories/location_repository_impl.dart';
import 'package:field_track/features/locations/domain/repositories/location_repository.dart';
import 'package:field_track/features/todos/data/database/app_database.dart';
import 'package:field_track/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:field_track/features/todos/data/datasources/todo_remote_datasource.dart';
import 'package:field_track/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:field_track/features/todos/domain/repositories/todo_repository.dart';
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

  if (!sl.isRegistered<AppDatabase>()) {
    sl.registerLazySingleton<AppDatabase>(AppDatabase.new);
  }

  if (!sl.isRegistered<TodoLocalDatasource>()) {
    sl.registerLazySingleton<TodoLocalDatasource>(
      () => TodoLocalDatasource(sl()),
    );
  }

  if (!sl.isRegistered<TodoRemoteDatasource>()) {
    sl.registerLazySingleton<TodoRemoteDatasource>(
      () => TodoRemoteDatasource(sl()),
    );
  }

  if (!sl.isRegistered<Connectivity>()) {
    sl.registerLazySingleton<Connectivity>(Connectivity.new);
  }

  if (!sl.isRegistered<TodoRepository>()) {
    sl.registerLazySingleton<TodoRepository>(
      () => TodoRepositoryImpl(remote: sl(), local: sl(), connectivity: sl()),
    );
  }

  if (!sl.isRegistered<GeofenceRegistry>()) {
    sl.registerLazySingleton<GeofenceRegistry>(GeofenceRegistryStub.new);
  }

  if (!sl.isRegistered<LocationRemoteDatasource>()) {
    sl.registerLazySingleton<LocationRemoteDatasource>(
      () => LocationRemoteDatasource(sl()),
    );
  }

  if (!sl.isRegistered<LocationLocalDatasource>()) {
    sl.registerLazySingleton<LocationLocalDatasource>(
      () => LocationLocalDatasource(sl()),
    );
  }

  if (!sl.isRegistered<LocationRepository>()) {
    sl.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(
        remote: sl(),
        local: sl(),
        geofenceRegistry: sl(),
      ),
    );
  }

  if (!sl.isRegistered<GoRouter>()) {
    sl.registerLazySingleton<GoRouter>(createAppRouter);
  }
}
