import 'package:get/get.dart';
import 'package:money_tracker/app/modules/categories/controllers/categories_controller.dart';
import 'package:money_tracker/app/modules/funds/controllers/funds_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FundsController>(() => FundsController());
    Get.lazyPut<CategoriesController>(() => CategoriesController());
  }
}
