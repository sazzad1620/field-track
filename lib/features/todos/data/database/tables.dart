import 'package:drift/drift.dart';

class TodoItems extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  BoolColumn get isCompleted => boolean()();
  TextColumn get dueAt => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PendingSyncItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get todoId => text()();
  BoolColumn get isCompleted => boolean()();
  TextColumn get updatedAt => text()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}
