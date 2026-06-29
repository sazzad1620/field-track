import 'package:field_track/core/di/injection.dart';
import 'package:field_track/core/router/app_routes.dart';
import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/widgets/loading_view.dart';
import 'package:field_track/features/auth/presentation/bloc/splash_bloc.dart';
import 'package:field_track/features/auth/presentation/bloc/splash_event.dart';
import 'package:field_track/features/auth/presentation/bloc/splash_state.dart';
import 'package:field_track/features/auth/presentation/widgets/field_track_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc(sl())..add(const SplashStarted()),
      child: BlocListener<SplashBloc, SplashState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == SplashStatus.authenticated) {
            context.go(AppRoutes.home);
          } else if (state.status == SplashStatus.unauthenticated) {
            context.go(AppRoutes.login);
          }
        },
        child: const Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FieldTrackLogo(),
              SizedBox(height: 32),
              LoadingView(),
            ],
          ),
        ),
      ),
    );
  }
}
