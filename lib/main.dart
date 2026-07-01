import 'package:field_track/app.dart';
import 'package:field_track/core/di/injection.dart';
import 'package:field_track/features/geofence/data/geofence_notification_service.dart';
import 'package:field_track/features/geofence/domain/geofence_registry.dart';
import 'package:field_track/features/locations/data/datasources/location_local_datasource.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
  await GeofenceNotificationService.init();
  await _bootstrapGeofences();
  runApp(const FieldTrackApp());
}

Future<void> _bootstrapGeofences() async {
  final local = sl<LocationLocalDatasource>();
  final registry = sl<GeofenceRegistry>();
  final locations = await local.getAll();
  await registry.refresh(
    locations.where((location) => location.isActive).toList(),
  );
}
