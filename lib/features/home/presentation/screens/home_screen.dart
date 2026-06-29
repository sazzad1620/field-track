import 'package:field_track/core/di/injection.dart';
import 'package:field_track/core/router/app_routes.dart';
import 'package:field_track/core/widgets/loading_view.dart';
import 'package:field_track/features/home/presentation/bloc/home_bloc.dart';
import 'package:field_track/features/home/presentation/bloc/home_event.dart';
import 'package:field_track/features/home/presentation/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(sl())..add(const HomeStarted()),
      child: BlocListener<HomeBloc, HomeState>(
        listenWhen: (prev, curr) => prev.loggedOut != curr.loggedOut,
        listener: (context, state) {
          if (state.loggedOut) {
            context.go(AppRoutes.login);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Field Track'),
            actions: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: () => context.read<HomeBloc>().add(
                          const HomeLogoutRequested(),
                        ),
                    icon: const Icon(Icons.logout),
                    tooltip: 'Log out',
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.status == HomeStatus.loading) {
                return const LoadingView();
              }

              final name = state.user?.name;
              final greeting = name != null && name.isNotEmpty ? 'Hi, $name' : 'Dashboard';

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    greeting,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.checklist_outlined),
                      title: const Text('Todos'),
                      subtitle: const Text('Your checklist'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: const Text('Locations'),
                      subtitle: const Text('Saved geofence areas'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
