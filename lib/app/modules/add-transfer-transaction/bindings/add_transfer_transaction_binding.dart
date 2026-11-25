import 'package:get/get.dart';

import '../controllers/add_transfer_transaction_controller.dart';

class AddTransferTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTransferTransactionController>(
      () => AddTransferTransactionController(),
    );
  }
}
