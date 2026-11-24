import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/app/data/database.dart';
import 'package:money_tracker/app/data/schemas/categories_schema.dart';

enum SortOrder { asc, desc }

enum SortBy { name, createdAt }

enum FilterBy { all, income, expense }

class CategoryRepo {
  final AppDatabase _db;
  CategoryRepo({required this._db});

  // CREATE
  Future<bool> createCategory({
    required String title,
    required CategoryType type,
    String? icon,
    Color? iconColor,
  }) async {
    final result = await _db
        .into(_db.categories)
        .insert(
          CategoriesCompanion.insert(
            title: title,
            type: type,
            icon: Value(icon),
            iconColor: Value(iconColor?.toARGB32()),
          ),
        );
    return result > 0;
  }

  // READ
  Stream<List<Category>> watchCategories({
    SortOrder sortOrder = SortOrder.desc,
    FilterBy filterBy = FilterBy.all,
    SortBy sortBy = SortBy.name,
  }) {
    final mode = sortOrder == SortOrder.desc
        ? OrderingMode.asc
        : OrderingMode.desc;

    return (_db.select(_db.categories)
          ..where(
            (tbl) => switch (filterBy) {
              FilterBy.all => const Constant(true),
              FilterBy.income => tbl.type.equalsValue(CategoryType.income),
              FilterBy.expense => tbl.type.equalsValue(CategoryType.expense),
            },
          )
          ..orderBy([
            (row) => switch (sortBy) {
              SortBy.name => OrderingTerm(expression: row.title, mode: mode),
              SortBy.createdAt => OrderingTerm(
                expression: row.createdAt,
                mode: mode,
              ),
            },
          ]))
        .watch();
  }

  Future<List<Category>> getCategories([CategoryType? type]) {
    final query = _db.select(_db.categories);

    if (type != null) {
      query.where((u) => u.type.equalsValue(type));
    }

    query.orderBy([(u) => OrderingTerm.asc(u.title)]);

    return query.get();
  }

  // UPDATE
  Future<bool> updateCategory({
    required int id,
    String? title,
    CategoryType? type,
    String? icon,
    Color? iconColor,
  }) async {
    final row =
        await (_db.update(
          _db.categories,
        )..where((tbl) => tbl.id.equals(id))).write(
          CategoriesCompanion(
            title: title == null ? const Value.absent() : Value(title),
            type: type == null ? const Value.absent() : Value(type),
            icon: Value(icon),
            iconColor: Value(iconColor?.toARGB32()),
          ),
        );
    return row > 0;
  }

  // DELETE
  Future<bool> deleteCategory(int id) async {
    final row = await (_db.delete(
      _db.categories,
    )..where((tbl) => tbl.id.equals(id))).go();
    return row > 0;
  }
}
