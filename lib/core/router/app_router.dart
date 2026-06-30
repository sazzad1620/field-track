import 'package:field_track/core/router/app_routes.dart';
import 'package:field_track/features/auth/presentation/screens/login_screen.dart';
import 'package:field_track/features/auth/presentation/screens/register_screen.dart';
import 'package:field_track/features/shell/presentation/screens/main_shell_screen.dart';
import 'package:field_track/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainShellScreen(),
      ),
    ],
  );
}
