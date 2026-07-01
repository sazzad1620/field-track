import 'package:equatable/equatable.dart';

enum LocationFormStatus { initial, locating, saving, success, failure, deleted }

class LocationFormState extends Equatable {
  final LocationFormStatus status;
  final String? locationId;
  final String locationName;
  final double latitude;
  final double longitude;
  final int radiusM;
  final bool isActive;
  final String? errorMessage;

  const LocationFormState({
    this.status = LocationFormStatus.initial,
    this.locationId,
    this.locationName = '',
    this.latitude = 25.2048,
    this.longitude = 55.2708,
    this.radiusM = 150,
    this.isActive = true,
    this.errorMessage,
  });

  bool get isEditing => locationId != null;

  LocationFormState copyWith({
    LocationFormStatus? status,
    String? locationId,
    String? locationName,
    double? latitude,
    double? longitude,
    int? radiusM,
    bool? isActive,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LocationFormState(
      status: status ?? this.status,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusM: radiusM ?? this.radiusM,
      isActive: isActive ?? this.isActive,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        locationId,
        locationName,
        latitude,
        longitude,
        radiusM,
        isActive,
        errorMessage,
      ];
}
