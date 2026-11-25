import 'package:get/get.dart';

import '../modules/add-category/bindings/add_category_binding.dart';
import '../modules/add-category/views/add_category_view.dart';
import '../modules/add-expense-transaction/bindings/add_expense_transaction_binding.dart';
import '../modules/add-expense-transaction/views/add_expense_transaction_view.dart';
import '../modules/add-fund/bindings/add_fund_binding.dart';
import '../modules/add-fund/views/add_fund_view.dart';
import '../modules/add-income-transaction/bindings/add_income_transaction_binding.dart';
import '../modules/add-income-transaction/views/add_income_transaction_view.dart';
import '../modules/add-transfer-transaction/bindings/add_transfer_transaction_binding.dart';
import '../modules/add-transfer-transaction/views/add_transfer_transaction_view.dart';
import '../modules/categories/bindings/categories_binding.dart';
import '../modules/categories/views/categories_view.dart';
import '../modules/edit-category/bindings/edit_category_binding.dart';
import '../modules/edit-category/views/edit_category_view.dart';
import '../modules/edit-fund/bindings/edit_fund_binding.dart';
import '../modules/edit-fund/views/edit_fund_view.dart';
import '../modules/funds/bindings/funds_binding.dart';
import '../modules/funds/views/funds_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const Views(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FUNDS,
      page: () => const FundsView(),
      binding: FundsBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORIES,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.ADD_FUND,
      page: () => const AddFundView(),
      binding: AddFundBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_FUND,
      page: () => const EditFundView(),
      binding: EditFundBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_CATEGORY,
      page: () => const EditCategoryView(),
      binding: EditCategoryBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CATEGORY,
      page: () => const AddCategoryView(),
      binding: AddCategoryBinding(),
    ),
    GetPage(
      name: _Paths.ADD_INCOME_TRANSACTION,
      page: () => const AddIncomeTransactionView(),
      binding: AddIncomeTransactionBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EXPENSE_TRANSACTION,
      page: () => const AddExpenseTransactionView(),
      binding: AddExpenseTransactionBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TRANSFER_TRANSACTION,
      page: () => const AddTransferTransactionView(),
      binding: AddTransferTransactionBinding(),
    ),
  ];
}
