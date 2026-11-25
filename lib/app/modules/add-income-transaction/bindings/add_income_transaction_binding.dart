import 'package:get/get.dart';

import '../controllers/add_income_transaction_controller.dart';

class AddIncomeTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddIncomeTransactionController>(
      () => AddIncomeTransactionController(),
    );
  }
}
