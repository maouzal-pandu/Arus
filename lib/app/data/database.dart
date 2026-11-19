import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:money_tracker/app/data/schemas/categories_schema.dart';
import 'package:money_tracker/app/data/schemas/funds_schema.dart';
import 'package:money_tracker/app/data/schemas/transaction_entry_schema.dart';
import 'package:money_tracker/app/data/schemas/transaction_items_schema.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Categories, Funds, TransactionEntry, TransactionItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? query]) : super(query ?? _openConnection());

  static QueryExecutor _openConnection() => driftDatabase(
    name: 'money_tracker_db',
    native: DriftNativeOptions(
      databaseDirectory: getApplicationSupportDirectory,
    ),
  );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },

    onUpgrade: (m, from, to) async {},

    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
