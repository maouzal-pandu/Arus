import 'package:drift/drift.dart';
import 'package:money_tracker/app/data/schemas/transaction_entry_schema.dart';

class TransactionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionEntryId => integer().references(
    TransactionEntry,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get pcs => integer()();
  IntColumn get price => integer()();
  IntColumn get total => integer().generatedAs(pcs * price, stored: true)();
  // DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
    'CHECK (pcs > 0)',
    'CHECK (price > 0)',
  ];
}
