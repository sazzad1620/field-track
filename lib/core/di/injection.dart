import 'package:dio/dio.dart';
import 'package:field_track/core/network/dio_client.dart';
import 'package:field_track/core/router/app_router.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final sl = GetIt.instance;

Future<void> setupInjection() async {
  sl.registerLazySingleton<Dio>(createDio);
  sl.registerLazySingleton<GoRouter>(createAppRouter);
}
