import 'package:field_track/features/locations/domain/repositories/location_repository.dart';
import 'package:field_track/features/locations/presentation/bloc/location_list_event.dart';
import 'package:field_track/features/locations/presentation/bloc/location_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationListBloc extends Bloc<LocationListEvent, LocationListState> {
  final LocationRepository repository;

  LocationListBloc(this.repository) : super(const LocationListState()) {
    on<LocationListStarted>(_onStarted);
    on<LocationListRefreshRequested>(_onRefresh);
    on<LocationSearchChanged>(_onSearch);
  }

  Future<void> _onStarted(
    LocationListStarted event,
    Emitter<LocationListState> emit,
  ) async {
    emit(state.copyWith(status: LocationListStatus.loading, clearError: true));
    try {
      final locations = await repository.fetchLocations();
      emit(
        state.copyWith(
          status: LocationListStatus.loaded,
          locations: locations,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefresh(
    LocationListRefreshRequested event,
    Emitter<LocationListState> emit,
  ) async {
    try {
      final locations = await repository.fetchLocations();
      emit(
        state.copyWith(
          status: LocationListStatus.loaded,
          locations: locations,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onSearch(LocationSearchChanged event, Emitter<LocationListState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
