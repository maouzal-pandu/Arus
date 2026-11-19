import 'package:get/get.dart';

import '../controllers/funds_controller.dart';

class FundsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FundsController>(
      () => FundsController(),
    );
  }
}
