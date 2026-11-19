import 'package:get/get.dart';

import '../controllers/edit_fund_controller.dart';

class EditFundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditFundController>(
      () => EditFundController(),
    );
  }
}
