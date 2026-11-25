import 'package:get/get.dart';

import '../controllers/add_expense_transaction_controller.dart';

class AddExpenseTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddExpenseTransactionController>(
      () => AddExpenseTransactionController(),
    );
  }
}
