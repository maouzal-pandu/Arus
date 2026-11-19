import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_tracker/app/components/snackbar.dart';
import 'package:money_tracker/app/data/repos/fund_repo.dart';
import 'package:money_tracker/app/data/schemas/funds_schema.dart';

class AddFundController extends GetxController {
  final _repo = Get.find<FundRepo>();

  final formK = GlobalKey<FormState>();
  // controllers
  final titleC = TextEditingController();
  final Rx<FundType> type = FundType.cash.obs;
  final amountC = TextEditingController();

  Future<void> createFund() async {
    if (!formK.currentState!.validate()) return;

    final title = titleC.text;
    final amount = int.parse(amountC.text.replaceAll('.', ''));

    final result = await _repo.createFund(
      title: title,
      type: type.value,
      amount: amount,
    );

    if (result) {
      Get.back();
      showSnackbar(result, 'Success', 'Funds Created');
    } else {
      showSnackbar(result, 'Failed', 'Fund Failed');
    }
  }
}
