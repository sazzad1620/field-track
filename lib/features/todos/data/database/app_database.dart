import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:field_track/features/todos/data/database/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TodoItems, PendingSyncItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'field_track_db');
}
