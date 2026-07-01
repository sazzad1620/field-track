import 'package:field_track/features/geofence/data/geofence_notification_service.dart';
import 'package:field_track/features/geofence/data/geofence_notify_state.dart';
import 'package:field_track/features/locations/domain/entities/location.dart';
import 'package:geolocator/geolocator.dart';

/// One-shot GPS check after geofences register — covers emulator + already-inside.
class GeofenceImmediateEntry {
  static Future<void> check(List<Location> active) async {
    if (active.isEmpty) return;

    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      for (final location in active) {
        if (await GeofenceNotifyState.isNotifiedInside(location.id)) continue;

        final radius =
            location.radiusM < 100 ? 100.0 : location.radiusM.toDouble();
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          location.latitude,
          location.longitude,
        );
        if (distance <= radius) {
          await GeofenceNotificationService.showEntry(location.locationName);
          await GeofenceNotifyState.markInside(location.id);
        }
      }
    } catch (_) {
      // OS geofence monitoring remains the primary path.
    }
  }
}
