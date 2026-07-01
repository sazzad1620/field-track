import 'package:field_track/core/di/injection.dart';
import 'package:field_track/core/router/app_routes.dart';
import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/widgets/nested_bottom_nav.dart';
import 'package:field_track/features/geofence/domain/geofence_registry.dart';
import 'package:field_track/features/home/presentation/bloc/home_bloc.dart';
import 'package:field_track/features/locations/data/datasources/location_local_datasource.dart';
import 'package:field_track/features/home/presentation/bloc/home_event.dart';
import 'package:field_track/features/home/presentation/bloc/home_state.dart';
import 'package:field_track/features/locations/presentation/bloc/location_list_bloc.dart';
import 'package:field_track/features/locations/presentation/bloc/location_list_event.dart';
import 'package:field_track/features/locations/presentation/screens/location_list_screen.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_bloc.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_event.dart';
import 'package:field_track/features/profile/presentation/screens/profile_screen.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshGeofences());
  }

  Future<void> _refreshGeofences() async {
    final local = sl<LocationLocalDatasource>();
    final registry = sl<GeofenceRegistry>();
    final locations = await local.getAll();
    await registry.refresh(
      locations.where((location) => location.isActive).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TodoListBloc(sl())..add(const TodoListStarted()),
        ),
        BlocProvider(
          create: (_) => LocationListBloc(sl())..add(const LocationListStarted()),
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
                LocationListScreen(),
                SyncScreen(),
                ProfileScreen(),
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
