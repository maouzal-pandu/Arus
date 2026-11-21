import 'dart:async';

import 'package:get/get.dart';
import 'package:money_tracker/app/components/snackbar.dart';
import 'package:money_tracker/app/data/database.dart';
import 'package:money_tracker/app/data/repos/category_repo.dart';
import 'package:money_tracker/app/data/schemas/categories_schema.dart';

class CategoriesController extends GetxController {
  final _repo = Get.find<CategoryRepo>();
  final Rx<FilterBy> filterBy = FilterBy.all.obs;
  final Rx<SortBy> sortBy = SortBy.name.obs;
  final Rx<SortOrder> sortOrder = SortOrder.desc.obs;

  final RxList<Category> categoryList = <Category>[].obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();

    bindCategories();

    everAll([filterBy, sortBy, sortOrder], (_) => _scheduleBind());
  }

  @override
  void onClose() {
    super.onClose();
    _debounce?.cancel();
  }

  String getCategoryType(CategoryType x) => switch (x) {
    CategoryType.income => 'Income',
    CategoryType.expense => 'Expense',
  };

  Future<void> deleteCategory(int id) async {
    final result = await _repo.deleteCategory(id);

    if (result) {
      showSnackbar(result, 'Success', 'Success deleted fund');
    } else {
      showSnackbar(result, 'Failed', 'Failed to delete fund');
    }
  }

  void resetFilterAndSort() {
    Get.back();

    filterBy.value = FilterBy.all;
    sortOrder.value = SortOrder.desc;
    sortBy.value = SortBy.name;
  }

  void _scheduleBind() {
    _debounce?.cancel();
    Timer(Duration(milliseconds: 50), () => bindCategories());
    print(categoryList);
  }

  void bindCategories() {
    categoryList.bindStream(
      _repo.watchCategories(
        filterBy: filterBy.value,
        sortBy: sortBy.value,
        sortOrder: sortOrder.value,
      ),
    );
  }
}
