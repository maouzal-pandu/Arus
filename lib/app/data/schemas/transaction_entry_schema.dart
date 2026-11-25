import 'package:drift/drift.dart';
import 'package:money_tracker/app/data/schemas/categories_schema.dart';
import 'package:money_tracker/app/data/schemas/funds_schema.dart';

enum TransactionType { income, expense, transfer }

class TransactionEntry extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get fundId => integer().references(Funds, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get type => intEnum<TransactionType>()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description =>
      text().withLength(min: 1, max: 500).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
