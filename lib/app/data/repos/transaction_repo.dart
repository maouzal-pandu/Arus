import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:money_tracker/app/data/database.dart';
import 'package:money_tracker/app/data/schemas/transaction_entry_schema.dart';

enum FilterBy { all, income, expense }

enum SortOrder { asc, desc }

enum SortBy { name, amount, date }

class TransactionRepo {
  final AppDatabase _db;

  const TransactionRepo({required this._db});

  // CREATE
  Future<bool> recordExpenseTransaction(
    int fundId,
    int categoryId,
    String title,
    String? description,
    List<({String name, int pcs, int price})> items,
  ) async {
    await _db.transaction(() async {
      final entryId = await _db
          .into(_db.transactionEntry)
          .insert(
            TransactionEntryCompanion.insert(
              fundId: fundId,
              categoryId: categoryId,
              title: title,
              description: Value(description),
              type: TransactionType.expense,
            ),
          );

      await _db.batch((batch) {
        batch.insertAll(
          _db.transactionItems,
          items.map(
            (item) => TransactionItemsCompanion.insert(
              transactionEntryId: entryId,
              name: item.name,
              pcs: item.pcs,
              price: item.price,
            ),
          ),
        );
      });

      final total = items.fold<int>(
        0,
        (prev, val) => prev + val.price * val.pcs,
      );
      _db.customUpdate(
        'UPDATE funds SET amount = amount - ? WHERE id = ?',
        updates: {_db.funds},
        variables: [Variable.withInt(total), Variable.withInt(fundId)],
      );
    });
    return true;
  }

  Future<bool> recordIncomeTransaction(
    int fundId,
    int categoryId,
    String title,
    int amount, [
    String? description,
  ]) async {
    try {
      await _db.transaction(() async {
        final entryId = await _db
            .into(_db.transactionEntry)
            .insert(
              TransactionEntryCompanion.insert(
                fundId: fundId,
                categoryId: categoryId,
                title: title,
                description: Value(description),
                type: TransactionType.income,
              ),
            );

        await _db
            .into(_db.transactionItems)
            .insert(
              TransactionItemsCompanion.insert(
                transactionEntryId: entryId,
                name: title,
                pcs: 1,
                price: amount,
              ),
            );

        await _db.customUpdate(
          'UPDATE funds SET amount = amount + ? WHERE id = ?',
          updates: {_db.funds},
          variables: [Variable.withInt(amount), Variable.withInt(fundId)],
        );
      });

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return false;
    }
  }

  // READ
  Stream<List<TransactionEntryData>> watchTransactionEntry({
    FilterBy filterBy = FilterBy.all,
    SortOrder sortOrder = SortOrder.asc,
    SortBy sortBy = SortBy.name,
  }) {
    final mode = switch (sortOrder) {
      SortOrder.asc => OrderingMode.asc,
      SortOrder.desc => OrderingMode.desc,
    };

    return (_db.select(_db.transactionEntry)
          ..where(
            (transactions) => switch (filterBy) {
              FilterBy.all => const Constant(true),
              FilterBy.income => transactions.type.equalsValue(
                TransactionType.income,
              ),
              FilterBy.expense => throw UnimplementedError(),
            },
          )
          ..orderBy([
            (transactions) => switch (sortBy) {
              SortBy.name => OrderingTerm(
                expression: transactions.title,
                mode: mode,
              ),
              SortBy.amount => OrderingTerm(
                expression: CustomExpression(
                  'SELECT COALESCE(SUM(total), 0) FROM transaction_items'
                  'WHERE transaction_items.transaction_entry_id = transaction_entry.id',
                ),
                mode: mode,
              ),
              SortBy.date => OrderingTerm(
                expression: transactions.createdAt,
                mode: mode,
              ),
            },
          ]))
        .watch();
  }
}
