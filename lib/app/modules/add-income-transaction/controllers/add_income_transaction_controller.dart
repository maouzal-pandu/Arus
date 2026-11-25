import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_tracker/app/components/snackbar.dart';
import 'package:money_tracker/app/data/database.dart';
import 'package:money_tracker/app/data/repos/category_repo.dart';
import 'package:money_tracker/app/data/repos/fund_repo.dart';
import 'package:money_tracker/app/data/repos/transaction_repo.dart';
import 'package:money_tracker/app/data/schemas/categories_schema.dart';

class AddIncomeTransactionController extends GetxController {
  // form state
  final formK = GlobalKey<FormState>();
  // controllers
  final titleC = TextEditingController();
  final descriptionC = TextEditingController();
  final Rxn<Fund> fund = Rxn();
  final Rxn<Category> category = Rxn();
  final amountC = TextEditingController();

  // repos
  final _fundRepo = Get.find<FundRepo>();
  final _categoriesRepo = Get.find<CategoryRepo>();
  final _transactionRepo = Get.find<TransactionRepo>();

  // vars
  final RxList<Fund> funds = <Fund>[].obs;
  final RxList<Category> categories = <Category>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() async {
    await _fetchs();
    super.onInit();
  }

  Future<void> _fetchs() async {
    try {
      funds.assignAll(await _fundRepo.getFunds());
      categories.assignAll(
        await _categoriesRepo.getCategories(CategoryType.income),
      );
      if (funds.isNotEmpty) fund.value = funds.first;
      if (categories.isNotEmpty) category.value = categories.first;
    } finally {
      Future.delayed(
        Duration(milliseconds: 500),
        () => isLoading.value = false,
      );
    }
  }

  bool get hasChanges {
    final title = titleC.text.trim();
    final description = descriptionC.text.trim();

    return title.isNotEmpty ||
        description.isNotEmpty ||
        amountC.text.isNotEmpty;
  }

  Future<bool> showDiscardChangesDialog() async {
    if (!hasChanges) return true;

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your changes have not been saved.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> recordTransaction() async {
    if (!formK.currentState!.validate()) return;

    final title = titleC.text.trim();
    final amount = int.parse(amountC.text.replaceAll('.', ''));
    final description = descriptionC.text.trim();

    final result = await _transactionRepo.recordIncomeTransaction(
      fund.value!.id,
      category.value!.id,
      title,
      amount,
      description,
    );

    if (result) {
      Get.back();
      showSnackbar(result, 'Success', 'message');
    } else {
      showSnackbar(result, 'Failed', 'message');
    }
  }
}
