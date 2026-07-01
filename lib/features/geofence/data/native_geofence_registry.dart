import 'package:field_track/features/geofence/data/geofence_immediate_entry.dart';
import 'package:field_track/features/geofence/data/geofence_location_cache.dart';
import 'package:field_track/features/geofence/data/geofence_notify_state.dart';
import 'package:field_track/features/geofence/data/geofence_permissions.dart';
import 'package:field_track/features/geofence/domain/geofence_registry.dart';
import 'package:field_track/features/geofence/geofence_callback.dart';
import 'package:field_track/features/locations/domain/entities/location.dart';
import 'package:native_geofence/native_geofence.dart' as ng;

class NativeGeofenceRegistry implements GeofenceRegistry {
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await ng.NativeGeofenceManager.instance.initialize();
    _initialized = true;
  }

  @override
  Future<void> refresh(List<Location> locations) async {
    await _ensureInitialized();

    final active = locations.where((location) => location.isActive).toList();
    if (active.isEmpty) {
      await GeofenceLocationCache.save(const []);
      final registered =
          await ng.NativeGeofenceManager.instance.getRegisteredGeofences();
      for (final geofence in registered) {
        await ng.NativeGeofenceManager.instance.removeGeofenceById(geofence.id);
      }
      return;
    }

    if (!await GeofencePermissions.ensure()) return;

    await GeofenceLocationCache.save(active);

    final registered =
        await ng.NativeGeofenceManager.instance.getRegisteredGeofences();
    final desiredIds = active.map((location) => location.id).toSet();

    for (final geofence in registered) {
      if (!desiredIds.contains(geofence.id)) {
        await ng.NativeGeofenceManager.instance.removeGeofenceById(geofence.id);
        await GeofenceNotifyState.clearInside(geofence.id);
      }
    }

    for (final location in active) {
      await _upsertGeofence(location);
    }

    await GeofenceImmediateEntry.check(active);
  }

  Future<void> _upsertGeofence(Location location) async {
    final radius = location.radiusM < 100 ? 100.0 : location.radiusM.toDouble();

    final geofence = ng.Geofence(
      id: location.id,
      location: ng.Location(
        latitude: location.latitude,
        longitude: location.longitude,
      ),
      radiusMeters: radius,
      triggers: {ng.GeofenceEvent.enter, ng.GeofenceEvent.exit},
      iosSettings: const ng.IosGeofenceSettings(initialTrigger: true),
      androidSettings: ng.AndroidGeofenceSettings(
        initialTriggers: {ng.GeofenceEvent.enter},
      ),
    );

    try {
      await ng.NativeGeofenceManager.instance.removeGeofenceById(location.id);
    } catch (_) {}

    await ng.NativeGeofenceManager.instance.createGeofence(
      geofence,
      onGeofenceTriggered,
    );
  }
}
