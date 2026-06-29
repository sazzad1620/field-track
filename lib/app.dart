import 'package:field_track/core/di/injection.dart';
import 'package:field_track/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FieldTrackApp extends StatelessWidget {
  const FieldTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Field Track',
      theme: AppTheme.lightTheme,
      routerConfig: sl<GoRouter>(),
    );
  }
}
