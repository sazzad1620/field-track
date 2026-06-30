import 'package:drift/drift.dart';
import 'package:field_track/features/locations/domain/entities/location.dart';
import 'package:field_track/features/todos/data/database/app_database.dart';

class LocationLocalDatasource {
  final AppDatabase db;

  LocationLocalDatasource(this.db);

  Future<List<Location>> getAll() async {
    final rows = await db.select(db.locationItems).get();
    return rows.map(_toEntity).toList();
  }

  Future<void> upsert(Location location) async {
    await db.into(db.locationItems).insertOnConflictUpdate(_toCompanion(location));
  }

  Future<void> syncActiveFromApi(List<Location> apiLocations) async {
    for (final location in apiLocations) {
      await upsert(location);
    }
  }

  Future<void> remove(String id) async {
    await (db.delete(db.locationItems)..where((t) => t.id.equals(id))).go();
  }

  Location _toEntity(LocationItem row) {
    return Location(
      id: row.id,
      locationName: row.locationName,
      latitude: row.latitude,
      longitude: row.longitude,
      radiusM: row.radiusM,
      isActive: row.isActive,
    );
  }

  LocationItemsCompanion _toCompanion(Location location) {
    return LocationItemsCompanion(
      id: Value(location.id),
      locationName: Value(location.locationName),
      latitude: Value(location.latitude),
      longitude: Value(location.longitude),
      radiusM: Value(location.radiusM),
      isActive: Value(location.isActive),
    );
  }
}
