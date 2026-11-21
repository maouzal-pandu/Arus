import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_tracker/app/components/snackbar.dart';
import 'package:money_tracker/app/data/database.dart';
import 'package:money_tracker/app/data/repos/category_repo.dart';
import 'package:money_tracker/app/data/schemas/categories_schema.dart';

class EditCategoryController extends GetxController {
  late Category category;

  final _repo = Get.find<CategoryRepo>();

  final formK = GlobalKey<FormState>();
  // controllers
  final titleC = TextEditingController();
  final Rx<CategoryType> type = CategoryType.income.obs;
  final Rxn<String> icon = Rxn();
  final Rxn<Color> iconColor = Rxn();

  @override
  void onInit() {
    super.onInit();

    category = Get.arguments;

    titleC.text = category.title;
    type.value = category.type;
    if (category.icon != null) icon.value = category.icon;
    if (category.iconColor != null) {
      iconColor.value = Color(category.iconColor!);
    }
  }

  bool get hasChanges =>
      category.title != titleC.text ||
      category.type != type.value ||
      category.icon != icon.value ||
      category.iconColor != iconColor.value?.toARGB32();

  Future<bool> showDiscardChangesDialog() async {
    if (!hasChanges) return true;

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your changes have not been saved.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> editCategory() async {
    if (!formK.currentState!.validate()) return;

    final title = titleC.text.trim().capitalizeFirst;

    final result = await _repo.updateCategory(
      id: category.id,
      title: title,
      type: type.value,
      icon: icon.value,
      iconColor: iconColor.value,
    );

    if (result) {
      Get.back();
      showSnackbar(result, 'Success', 'Category Created');
    } else {
      showSnackbar(result, 'Failed', 'Category Failed');
    }
  }
}
