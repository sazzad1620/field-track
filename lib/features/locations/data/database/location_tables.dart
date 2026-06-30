import 'package:drift/drift.dart';

class LocationItems extends Table {
  TextColumn get id => text()();
  TextColumn get locationName => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  IntColumn get radiusM => integer()();
  BoolColumn get isActive => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
