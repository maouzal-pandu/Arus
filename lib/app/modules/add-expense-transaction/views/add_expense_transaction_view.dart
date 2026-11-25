import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_expense_transaction_controller.dart';

class AddExpenseTransactionView
    extends GetView<AddExpenseTransactionController> {
  const AddExpenseTransactionView({super.key});

  Future<void> _onBack() async {
    if (await controller.showDiscardChangesDialog()) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: _onBack,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              padding: EdgeInsets.all(4),
              child: Center(
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      body: const Center(
        child: Text(
          'AddExpenseTransactionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
