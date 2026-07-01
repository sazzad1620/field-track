import 'package:field_track/features/locations/domain/entities/location.dart';

abstract class GeofenceRegistry {
  Future<void> refresh(List<Location> locations);
}

class GeofenceRegistryStub implements GeofenceRegistry {
  @override
  Future<void> refresh(List<Location> locations) async {}
}