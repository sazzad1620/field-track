import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:field_track/features/locations/data/database/location_tables.dart';
import 'package:field_track/features/todos/data/database/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TodoItems, PendingSyncItems, SyncMeta, LocationItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await m.database.customStatement(
            'INSERT INTO sync_meta (id) VALUES (1)',
          );
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(locationItems);
          }
          if (from < 3) {
            await m.createTable(syncMeta);
            await m.database.customStatement(
              'INSERT INTO sync_meta (id) VALUES (1)',
            );
          }
        },
      );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'field_track_db');
}
