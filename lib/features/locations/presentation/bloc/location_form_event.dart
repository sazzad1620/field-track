import 'package:equatable/equatable.dart';
import 'package:field_track/features/locations/domain/entities/location.dart';

abstract class LocationFormEvent extends Equatable {
  const LocationFormEvent();

  @override
  List<Object?> get props => [];
}

class LocationFormStarted extends LocationFormEvent {
  final Location? existing;

  const LocationFormStarted({this.existing});

  @override
  List<Object?> get props => [existing];
}

class LocationFormSubmitted extends LocationFormEvent {
  final String locationName;
  final double latitude;
  final double longitude;
  final int radiusM;
  final bool isActive;

  const LocationFormSubmitted({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.radiusM,
    required this.isActive,
  });

  @override
  List<Object?> get props =>
      [locationName, latitude, longitude, radiusM, isActive];
}

class LocationFormDeleteRequested extends LocationFormEvent {
  const LocationFormDeleteRequested();
}

class LocationFormUseCurrentLocation extends LocationFormEvent {
  const LocationFormUseCurrentLocation();
}
