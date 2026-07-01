import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class GeofencePermissions {
  static Future<bool> ensure() async {
    final service = await Permission.location.serviceStatus;
    if (!service.isEnabled) return false;

    var location = await Permission.location.request();
    if (!location.isGranted) return false;

    if (Platform.isAndroid) {
      final notifications = await Permission.notification.request();
      if (!notifications.isGranted && !notifications.isLimited) {
        // Notifications help demo geofence entry; geofencing still works.
      }

      final background = await Permission.locationAlways.request();
      return background.isGranted;
    }

    final always = await Permission.locationAlways.request();
    return always.isGranted;
  }
}
