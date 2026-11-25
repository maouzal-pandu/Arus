import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseTransactionController extends GetxController {
  final formK = GlobalKey<FormState>();
  // controllers
  final title = TextEditingController();
  final description = TextEditingController();

  Future<bool> showDiscardChangesDialog() async {
    return true;
  }
}
