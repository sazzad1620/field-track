import 'package:field_track/features/locations/domain/entities/location.dart';

class LocationModel {
  final String id;
  final String locationName;
  final double latitude;
  final double longitude;
  final int radiusM;
  final bool isActive;

  const LocationModel({
    required this.id,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.radiusM,
    required this.isActive,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      locationName: json['location_name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusM: (json['radius_m'] as num).toInt(),
      isActive: _parseIsActive(json['is_active']),
    );
  }

  static bool _parseIsActive(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return true;
  }

  Location toEntity() {
    return Location(
      id: id,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      radiusM: radiusM,
      isActive: isActive,
    );
  }
}
