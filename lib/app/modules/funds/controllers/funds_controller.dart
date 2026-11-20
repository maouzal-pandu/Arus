import 'dart:async';

import 'package:get/get.dart';
import 'package:money_tracker/app/components/snackbar.dart';
import 'package:money_tracker/app/data/database.dart';
import 'package:money_tracker/app/data/repos/fund_repo.dart';
import 'package:money_tracker/app/data/schemas/funds_schema.dart';

class FundsController extends GetxController {
  final _repo = Get.find<FundRepo>();
  final Rx<FilterBy> filterBy = FilterBy.all.obs;
  final Rx<SortBy> sortBy = SortBy.name.obs;
  final Rx<SortOrder> sortOrder = SortOrder.desc.obs;

  final RxList<Fund> fundsList = <Fund>[].obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();

    _bindStream();

    everAll([filterBy, sortBy, sortOrder], (_) => _scheduleBind());
  }

  @override
  void onClose() {
    super.onClose();
    _debounce?.cancel();
  }

  void _scheduleBind() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 50), _bindStream);
  }

  void _bindStream() {
    fundsList.bindStream(
      _repo.watchFunds(
        filterBy: filterBy.value,
        sortBy: sortBy.value,
        sortOrder: sortOrder.value,
      ),
    );
  }

  Future<void> deleteFund(int id) async {
    final result = await _repo.deleteFund(id);

    if (result) {
      showSnackbar(result, 'Success', 'Success deleted fund');
    } else {
      showSnackbar(result, 'Failed', 'Failed to delete fund');
    }
  }

  String getType(FundType type) => switch (type) {
    FundType.cash => 'Cash',
    FundType.digital => 'Cashless',
  };

  void resetFilterAndSort() {
    Get.back();

    filterBy.value = FilterBy.all;
    sortOrder.value = SortOrder.desc;
    sortBy.value = SortBy.name;
  }
}
