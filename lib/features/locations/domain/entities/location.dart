import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String locationName;
  final double latitude;
  final double longitude;
  final int radiusM;
  final bool isActive;

  const Location({
    required this.id,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.radiusM,
    required this.isActive,
  });

  Location copyWith({
    String? locationName,
    double? latitude,
    double? longitude,
    int? radiusM,
    bool? isActive,
  }) {
    return Location(
      id: id,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusM: radiusM ?? this.radiusM,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        locationName,
        latitude,
        longitude,
        radiusM,
        isActive,
      ];
}
