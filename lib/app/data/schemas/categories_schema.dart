import 'package:drift/drift.dart';

enum CategoryType { income, expense }

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description =>
      text().nullable().withLength(min: 1, max: 500)();
  IntColumn get type => intEnum<CategoryType>()();
  TextColumn get icon => text().nullable()();
  IntColumn get iconColor => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
