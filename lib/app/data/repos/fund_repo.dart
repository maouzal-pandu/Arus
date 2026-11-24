import 'package:drift/drift.dart';
import 'package:money_tracker/app/data/database.dart';
import 'package:money_tracker/app/data/schemas/funds_schema.dart';

enum SortOrder { asc, desc }

enum SortBy { name, createdAt, amount }

enum FilterBy { all, cash, digital }

class FundRepo {
  final AppDatabase _db;

  FundRepo({required this._db});

  // CREATE
  Future<bool> createFund({
    required String title,
    required FundType type,
    int amount = 0,
  }) async {
    final result = await _db
        .into(_db.funds)
        .insert(
          FundsCompanion.insert(title: title, type: type, amount: amount),
        );
    return result > 0;
  }

  // READ
  Stream<List<Fund>> watchFunds({
    SortOrder sortOrder = SortOrder.desc,
    FilterBy filterBy = FilterBy.all,
    SortBy sortBy = SortBy.name,
  }) {
    final mode = sortOrder == SortOrder.desc
        ? OrderingMode.desc
        : OrderingMode.asc;

    return (_db.select(_db.funds)
          ..where(
            (tbl) => switch (filterBy) {
              FilterBy.all => const Constant(true),
              FilterBy.cash => tbl.type.equalsValue(FundType.cash),
              FilterBy.digital => tbl.type.equalsValue(FundType.digital),
            },
          )
          ..orderBy([
            (row) => switch (sortBy) {
              SortBy.name => OrderingTerm(expression: row.title, mode: mode),
              SortBy.createdAt => OrderingTerm(
                expression: row.createdAt,
                mode: mode,
              ),
              SortBy.amount => OrderingTerm(expression: row.amount, mode: mode),
            },
          ]))
        .watch();
  }

  Future<List<Fund>> getFunds() async => (_db.select(
    _db.funds,
  )..orderBy([(u) => OrderingTerm.asc(u.title)])).get();

  // UPDATE
  Future<bool> updateFund({
    required int id,
    required String title,
    required FundType type,
    required int amount,
  }) async {
    final row = await (_db.update(_db.funds)..where((tbl) => tbl.id.equals(id)))
        .write(
          FundsCompanion(
            title: Value(title),
            type: Value(type),
            amount: Value(amount),
          ),
        );
    return row > 0;
  }

  // DELETE
  Future<bool> deleteFund(int id) async {
    final row = await (_db.delete(
      _db.funds,
    )..where((tbl) => tbl.id.equals(id))).go();
    return row > 0;
  }
}
