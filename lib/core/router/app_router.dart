import 'package:field_track/core/router/app_routes.dart';
import 'package:field_track/features/auth/presentation/screens/login_screen.dart';
import 'package:field_track/features/auth/presentation/screens/register_screen.dart';
import 'package:field_track/features/auth/domain/entities/user.dart';
import 'package:field_track/features/locations/domain/entities/location.dart';
import 'package:field_track/features/locations/presentation/screens/location_form_screen.dart';
import 'package:field_track/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:field_track/features/profile/presentation/screens/help_support_screen.dart';
import 'package:field_track/features/profile/presentation/screens/notifications_screen.dart';
import 'package:field_track/features/profile/presentation/screens/settings_screen.dart';
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
      GoRoute(
        path: AppRoutes.locationAdd,
        builder: (context, state) => const LocationFormScreen(),
      ),
      GoRoute(
        path: '/locations/:id/edit',
        builder: (context, state) {
          final existing = state.extra as Location?;
          return LocationFormScreen(existing: existing);
        },
      ),
      GoRoute(
        path: AppRoutes.profileEdit,
        builder: (context, state) {
          final user = state.extra as User?;
          return EditProfileScreen(user: user);
        },
      ),
      GoRoute(
        path: AppRoutes.profileNotifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileHelp,
        builder: (context, state) => const HelpSupportScreen(),
      ),
    ],
  );
}
