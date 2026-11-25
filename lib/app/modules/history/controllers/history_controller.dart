import 'dart:async';

import 'package:get/get.dart';
import 'package:money_tracker/app/data/database.dart';
import 'package:money_tracker/app/data/repos/transaction_repo.dart';

class HistoryController extends GetxController {
  final history = <TransactionEntryData>[].obs;

  final filterBy = FilterBy.all.obs;
  final sortBy = SortBy.name.obs;
  final sortOrder = SortOrder.asc.obs;

  Timer? _debounce;

  final _repo = Get.find<TransactionRepo>();

  @override
  void onInit() {
    super.onInit();
    _bindStream();

    everAll([filterBy, sortBy, sortOrder], (_) => _scheduleBind());
  }

  @override
  void onClose() {
    super.onClose();

    _debounce!.cancel();
  }

  void _scheduleBind() {
    _debounce!.cancel();
    Timer(Duration(milliseconds: 50), _bindStream);
  }

  Future<void> _bindStream() async {
    history.bindStream(
      _repo.watchTransactionEntry(
        filterBy: filterBy.value,
        sortBy: sortBy.value,
        sortOrder: sortOrder.value,
      ),
    );
  }

  void resetFilterAndSort() {
    filterBy.value = FilterBy.all;
    sortBy.value = SortBy.name;
    sortOrder.value = SortOrder.asc;
  }

  void deleteTransaction(int id) {}
}
