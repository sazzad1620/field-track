import 'package:field_track/features/locations/domain/repositories/location_repository.dart';
import 'package:field_track/features/locations/presentation/bloc/location_form_event.dart';
import 'package:field_track/features/locations/presentation/bloc/location_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class LocationFormBloc extends Bloc<LocationFormEvent, LocationFormState> {
  final LocationRepository repository;

  LocationFormBloc(this.repository) : super(const LocationFormState()) {
    on<LocationFormStarted>(_onStarted);
    on<LocationFormSubmitted>(_onSubmitted);
    on<LocationFormDeleteRequested>(_onDelete);
    on<LocationFormUseCurrentLocation>(_onUseCurrentLocation);
  }

  void _onStarted(LocationFormStarted event, Emitter<LocationFormState> emit) {
    final existing = event.existing;
    if (existing == null) {
      emit(const LocationFormState(status: LocationFormStatus.initial));
      return;
    }
    emit(
      LocationFormState(
        status: LocationFormStatus.initial,
        locationId: existing.id,
        locationName: existing.locationName,
        latitude: existing.latitude,
        longitude: existing.longitude,
        radiusM: existing.radiusM,
        isActive: existing.isActive,
      ),
    );
  }

  Future<void> _onSubmitted(
    LocationFormSubmitted event,
    Emitter<LocationFormState> emit,
  ) async {
    emit(state.copyWith(status: LocationFormStatus.saving, clearError: true));
    try {
      if (state.isEditing) {
        await repository.updateLocation(
          id: state.locationId!,
          locationName: event.locationName,
          latitude: event.latitude,
          longitude: event.longitude,
          radiusM: event.radiusM,
          isActive: event.isActive,
        );
      } else {
        await repository.createLocation(
          locationName: event.locationName,
          latitude: event.latitude,
          longitude: event.longitude,
          radiusM: event.radiusM,
          isActive: event.isActive,
        );
      }
      emit(state.copyWith(status: LocationFormStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationFormStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDelete(
    LocationFormDeleteRequested event,
    Emitter<LocationFormState> emit,
  ) async {
    if (!state.isEditing) return;
    emit(state.copyWith(status: LocationFormStatus.saving, clearError: true));
    try {
      await repository.deleteLocation(state.locationId!);
      emit(state.copyWith(status: LocationFormStatus.deleted));
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationFormStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUseCurrentLocation(
    LocationFormUseCurrentLocation event,
    Emitter<LocationFormState> emit,
  ) async {
    emit(state.copyWith(status: LocationFormStatus.locating, clearError: true));
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        emit(
          state.copyWith(
            status: LocationFormStatus.failure,
            errorMessage: 'Location permission denied',
          ),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      emit(
        state.copyWith(
          status: LocationFormStatus.initial,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationFormStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
