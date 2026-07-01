import 'package:field_track/features/geofence/domain/geofence_registry.dart';
import 'package:field_track/features/locations/data/datasources/location_local_datasource.dart';
import 'package:field_track/features/locations/data/datasources/location_remote_datasource.dart';
import 'package:field_track/features/locations/domain/entities/location.dart';
import 'package:field_track/features/locations/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDatasource remote;
  final LocationLocalDatasource local;
  final GeofenceRegistry geofenceRegistry;

  LocationRepositoryImpl({
    required this.remote,
    required this.local,
    required this.geofenceRegistry,
  });

  @override
  Future<List<Location>> fetchLocations({bool refreshGeofences = true}) async {
    final models = await remote.fetchLocations();
    final apiLocations = models.map((m) => m.toEntity()).toList();
    await local.syncActiveFromApi(apiLocations);
    final locations = _orderedLocations(await local.getAll(), apiLocations);
    if (refreshGeofences) {
      await geofenceRegistry.refresh(
        locations.where((location) => location.isActive).toList(),
      );
    }
    return locations;
  }

  @override
  Future<Location> createLocation({
    required String locationName,
    required double latitude,
    required double longitude,
    required int radiusM,
    required bool isActive,
  }) async {
    final model = await remote.createLocation(
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      radiusM: radiusM,
    );
    final location = model.toEntity().copyWith(isActive: isActive);
    await local.upsert(location);
    await geofenceRegistry.refresh(
      (await local.getAll()).where((item) => item.isActive).toList(),
    );
    return location;
  }

  @override
  Future<Location> updateLocation({
    required String id,
    required String locationName,
    required double latitude,
    required double longitude,
    required int radiusM,
    required bool isActive,
  }) async {
    final model = await remote.updateLocation(
      id: id,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      radiusM: radiusM,
      isActive: isActive,
    );
    final location = model.toEntity();
    await local.upsert(location);
    await geofenceRegistry.refresh(
      (await local.getAll()).where((item) => item.isActive).toList(),
    );
    return location;
  }

  @override
  Future<void> deleteLocation(String id) async {
    await remote.deleteLocation(id);
    await local.remove(id);
    await geofenceRegistry.refresh(
      (await local.getAll()).where((item) => item.isActive).toList(),
    );
  }

  List<Location> _orderedLocations(
    List<Location> all,
    List<Location> apiOrder,
  ) {
    final byId = {for (final location in all) location.id: location};
    final ordered = <Location>[];
    final seen = <String>{};

    for (final location in apiOrder) {
      final cached = byId[location.id];
      if (cached != null) {
        ordered.add(cached);
        seen.add(location.id);
      }
    }

    for (final location in all) {
      if (!seen.contains(location.id)) {
        ordered.add(location);
      }
    }

    return ordered;
  }
}
