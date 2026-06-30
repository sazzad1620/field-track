import 'package:field_track/core/constants/shell_layout.dart';
import 'package:field_track/core/router/app_routes.dart';
import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/theme/app_decorations.dart';
import 'package:field_track/core/widgets/empty_view.dart';
import 'package:field_track/core/widgets/error_view.dart';
import 'package:field_track/core/widgets/loading_view.dart';
import 'package:field_track/features/locations/domain/entities/location.dart';
import 'package:field_track/features/locations/presentation/bloc/location_list_bloc.dart';
import 'package:field_track/features/locations/presentation/bloc/location_list_event.dart';
import 'package:field_track/features/locations/presentation/bloc/location_list_state.dart';
import 'package:field_track/features/locations/presentation/widgets/location_card.dart';
import 'package:field_track/features/locations/presentation/widgets/location_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key});

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAdd() async {
    await context.push(AppRoutes.locationAdd);
    if (!mounted) return;
    context.read<LocationListBloc>().add(const LocationListRefreshRequested());
  }

  Future<void> _openEdit(Location location) async {
    await context.push(AppRoutes.locationEditPath(location.id), extra: location);
    if (!mounted) return;
    context.read<LocationListBloc>().add(const LocationListRefreshRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationListBloc, LocationListState>(
      builder: (context, state) {
        if (state.status == LocationListStatus.loading && state.locations.isEmpty) {
          return const LoadingView();
        }

        if (state.status == LocationListStatus.failure && state.locations.isEmpty) {
          return ErrorView(
            message: state.errorMessage ?? 'Could not load locations',
            onRetry: () =>
                context.read<LocationListBloc>().add(const LocationListStarted()),
          );
        }

        final locations = state.filteredLocations;

        return Stack(
          children: [
            RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                context
                    .read<LocationListBloc>()
                    .add(const LocationListRefreshRequested());
                await context.read<LocationListBloc>().stream.firstWhere(
                      (s) => s.status != LocationListStatus.loading,
                    );
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        ShellLayout.contentHorizontalPadding,
                        8,
                        ShellLayout.contentHorizontalPadding,
                        14,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Locations',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 21,
                                height: 25 / 21,
                                letterSpacing: -0.42,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Material(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: _openAdd,
                              borderRadius: BorderRadius.circular(12),
                              child: const SizedBox(
                                width: 38,
                                height: 38,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      ShellLayout.contentHorizontalPadding,
                      4,
                      ShellLayout.contentHorizontalPadding,
                      100,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        LocationSearchBar(
                          controller: _searchController,
                          onChanged: (q) => context
                              .read<LocationListBloc>()
                              .add(LocationSearchChanged(q)),
                        ),
                        const SizedBox(height: 12),
                        if (locations.isEmpty)
                          const SizedBox(
                            height: 200,
                            child: EmptyView(message: 'No locations found'),
                          )
                        else
                          ...locations.map(
                            (location) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: LocationCard(
                                location: location,
                                onTap: () => _openEdit(location),
                              ),
                            ),
                          ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: ShellLayout.contentHorizontalPadding,
              bottom: 24,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppDecorations.fabShadow,
                ),
                child: Material(
                  color: AppColors.primary,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: _openAdd,
                    borderRadius: BorderRadius.circular(18),
                    child: const SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
