import 'package:field_track/features/locations/domain/entities/location.dart';

abstract class LocationRepository {
  Future<List<Location>> fetchLocations({bool refreshGeofences = true});

  Future<Location> createLocation({
    required String locationName,
    required double latitude,
    required double longitude,
    required int radiusM,
    required bool isActive,
  });

  Future<Location> updateLocation({
    required String id,
    required String locationName,
    required double latitude,
    required double longitude,
    required int radiusM,
    required bool isActive,
  });

  Future<void> deleteLocation(String id);
}
