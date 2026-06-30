import 'package:field_track/core/constants/shell_layout.dart';
import 'package:field_track/core/di/injection.dart';
import 'package:field_track/core/router/app_routes.dart';
import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/widgets/loading_view.dart';
import 'package:field_track/core/widgets/nested_bottom_nav.dart';
import 'package:field_track/features/home/presentation/bloc/home_bloc.dart';
import 'package:field_track/features/home/presentation/bloc/home_event.dart';
import 'package:field_track/features/home/presentation/bloc/home_state.dart';
import 'package:field_track/features/locations/presentation/screens/locations_placeholder_screen.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_bloc.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_event.dart';
import 'package:field_track/features/todos/presentation/screens/sync_screen.dart';
import 'package:field_track/features/todos/presentation/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _index = 0;

  static const _tabs = [
    NestedBottomNavItem(label: 'Tasks', icon: Icons.format_list_bulleted),
    NestedBottomNavItem(label: 'Locations', icon: Icons.location_on_outlined),
    NestedBottomNavItem(label: 'Sync', icon: Icons.sync),
    NestedBottomNavItem(label: 'Profile', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TodoListBloc(sl())..add(const TodoListStarted()),
        ),
        BlocProvider(
          create: (_) => HomeBloc(sl())..add(const HomeStarted()),
        ),
      ],
      child: BlocListener<HomeBloc, HomeState>(
        listenWhen: (prev, curr) => prev.loggedOut != curr.loggedOut,
        listener: (context, state) {
          if (state.loggedOut) {
            context.go(AppRoutes.login);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _index,
              children: const [
                TodoListScreen(),
                LocationsPlaceholderScreen(),
                SyncScreen(),
                _ProfileTab(),
              ],
            ),
          ),
          bottomNavigationBar: NestedBottomNav(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            items: _tabs,
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return const LoadingView();
        }

        final user = state.user;
        final name = user?.name ?? 'User';
        final email = user?.email ?? '';

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            ShellLayout.contentHorizontalPadding,
            8,
            ShellLayout.contentHorizontalPadding,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 21,
                  height: 25 / 21,
                  letterSpacing: -0.42,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.focusRing,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (email.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.read<HomeBloc>().add(
                        const HomeLogoutRequested(),
                      ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Log out'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
