import 'package:field_track/core/router/app_routes.dart';
import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/widgets/loading_view.dart';
import 'package:field_track/features/home/presentation/bloc/home_bloc.dart';
import 'package:field_track/features/home/presentation/bloc/home_event.dart';
import 'package:field_track/features/home/presentation/bloc/home_state.dart';
import 'package:field_track/features/locations/presentation/bloc/location_list_bloc.dart';
import 'package:field_track/features/locations/presentation/bloc/location_list_state.dart';
import 'package:field_track/features/profile/core/profile_helpers.dart';
import 'package:field_track/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:field_track/features/profile/presentation/widgets/profile_menu_row.dart';
import 'package:field_track/features/profile/presentation/widgets/profile_sign_out_button.dart';
import 'package:field_track/features/profile/presentation/widgets/profile_stat_card.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_bloc.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  /// Figma profile content inset: `padding: 4px 20px 92px`.
  static const _horizontalPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        if (homeState.status == HomeStatus.loading) {
          return const LoadingView();
        }

        final user = homeState.user;
        final name = user?.name ?? 'User';
        final email = user?.email ?? '';
        final role = user?.role ?? '';

        return BlocBuilder<TodoListBloc, TodoListState>(
          builder: (context, todoState) {
            return BlocBuilder<LocationListBloc, LocationListState>(
              builder: (context, locationState) {
                final doneToday = countTasksDoneToday(todoState.todos);
                final totalTasks = todoState.totalCount;
                final activeLocations = locationState.locations
                    .where((location) => location.isActive)
                    .length;

                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          _horizontalPadding,
                          8,
                          _horizontalPadding,
                          14,
                        ),
                        child: const Text(
                          'Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 21,
                            height: 25 / 21,
                            letterSpacing: -0.42,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        _horizontalPadding,
                        4,
                        _horizontalPadding,
                        92,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          ProfileHeaderCard(
                            name: name,
                            email: email,
                            role: role,
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              ProfileStatCard(
                                value: '$doneToday/$totalTasks',
                                label: 'Tasks done today',
                              ),
                              const SizedBox(width: 12),
                              ProfileStatCard(
                                value: '$activeLocations',
                                label: 'Active locations',
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          ProfileMenuCard(
                            children: [
                              ProfileMenuRow(
                                icon: Icons.person_outline,
                                label: 'Edit profile',
                                onTap: () => context.push(
                                  AppRoutes.profileEdit,
                                  extra: user,
                                ),
                              ),
                              ProfileMenuRow(
                                icon: Icons.notifications_outlined,
                                label: 'Notifications',
                                onTap: () =>
                                    context.push(AppRoutes.profileNotifications),
                              ),
                              ProfileMenuRow(
                                icon: Icons.settings_outlined,
                                label: 'Settings',
                                onTap: () =>
                                    context.push(AppRoutes.profileSettings),
                              ),
                              ProfileMenuRow(
                                icon: Icons.help_outline,
                                label: 'Help & support',
                                showDivider: false,
                                onTap: () => context.push(AppRoutes.profileHelp),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          ProfileSignOutButton(
                            onPressed: () => context.read<HomeBloc>().add(
                                  const HomeLogoutRequested(),
                                ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
