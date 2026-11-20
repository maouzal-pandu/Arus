import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/app/components/snackbar.dart';
import 'package:money_tracker/app/data/database.dart';
import 'package:money_tracker/app/data/repos/fund_repo.dart';
import 'package:money_tracker/app/data/schemas/funds_schema.dart';

class EditFundController extends GetxController {
  late Fund fund;

  final _repo = Get.find<FundRepo>();

  final formK = GlobalKey<FormState>();
  // controllers
  final titleC = TextEditingController();
  final Rx<FundType> type = FundType.cash.obs;
  final amountC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fund = Get.arguments;

    titleC.text = fund.title;
    type.value = fund.type;
    amountC.text = NumberFormat.decimalPattern('id_ID').format(fund.amount);
  }

  bool get hasChanges {
    final currentAmount = int.parse(amountC.text.replaceAll('.', ''));

    return titleC.text.trim() != fund.title ||
        currentAmount != fund.amount ||
        type.value != fund.type;
  }

  Future<bool> showExitDialog() async {
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

  Future<void> editFund() async {
    if (!formK.currentState!.validate()) return;

    final title = titleC.text;
    final amount = int.parse(amountC.text.replaceAll('.', ''));

    final result = await _repo.updateFund(
      id: fund.id,
      title: title,
      type: type.value,
      amount: amount,
    );

    if (result) {
      Get.back();
      showSnackbar(result, 'Success', 'Funds Updated');
    } else {
      showSnackbar(result, 'Failed', 'Fund Failed Updated');
    }
  }
}
