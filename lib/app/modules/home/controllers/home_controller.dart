import 'package:get/get.dart';

class HomeController extends GetxController {
  final pageIndex = 0.obs;
  final isFabOpen = false.obs;

  void toggleFab() => isFabOpen.toggle();
}
