import 'package:field_track/features/geofence/data/geofence_location_cache.dart';
import 'package:field_track/features/geofence/data/geofence_notification_service.dart';
import 'package:field_track/features/geofence/data/geofence_notify_state.dart';
import 'package:flutter/widgets.dart';
import 'package:native_geofence/native_geofence.dart';

@pragma('vm:entry-point')
Future<void> onGeofenceTriggered(GeofenceCallbackParams params) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (params.event == GeofenceEvent.exit) {
    for (final geofence in params.geofences) {
      await GeofenceNotifyState.clearInside(geofence.id);
    }
    return;
  }

  if (params.event != GeofenceEvent.enter) return;

  for (final geofence in params.geofences) {
    if (await GeofenceNotifyState.isNotifiedInside(geofence.id)) continue;

    final name =
        await GeofenceLocationCache.nameFor(geofence.id) ?? 'a saved location';
    await GeofenceNotificationService.showEntry(name);
    await GeofenceNotifyState.markInside(geofence.id);
  }
}
