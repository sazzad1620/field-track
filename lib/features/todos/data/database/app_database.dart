import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:field_track/features/locations/data/database/location_tables.dart';
import 'package:field_track/features/todos/data/database/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TodoItems, PendingSyncItems, LocationItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(locationItems);
          }
        },
      );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'field_track_db');
}
