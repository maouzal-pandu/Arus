import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/core/theme/app_colors.dart';
import 'package:money_tracker/app/data/schemas/transaction_entry_schema.dart';

import '../../../components/section_options.dart';
import '../../../data/repos/transaction_repo.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  void _showFilter(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => Container(
      height: 600,
      width: double.infinity,
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: const SizedBox()),

                  const Text(
                    'Filter',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                    ),
                  ),

                  Expanded(
                    child: Align(
                      alignment: AlignmentGeometry.centerRight,
                      child: TextButton(
                        onPressed: () => controller.resetFilterAndSort(),
                        child: const Text('Reset'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 1, width: double.infinity, child: Divider()),

            const SizedBox(height: 8),

            sectionOption<SortBy>(
              'Sort By',
              ['Name', 'Amount', 'Date'],
              [SortBy.name, SortBy.amount, SortBy.date],
              controller.sortBy,
            ),

            const SizedBox(
              height: 1,
              width: double.infinity,
              child: Divider(indent: 3, endIndent: 3),
            ),

            const SizedBox(height: 12),

            sectionOption<SortOrder>(
              'Sort Order',
              ['Asc', 'Desc'],
              [SortOrder.asc, SortOrder.desc],
              controller.sortOrder,
            ),

            const SizedBox(
              height: 1,
              width: double.infinity,
              child: Divider(indent: 3, endIndent: 3),
            ),

            const SizedBox(height: 12),

            sectionOption<FilterBy>(
              'Filter By',
              ['Income', 'Expense'],
              [FilterBy.income, FilterBy.expense],
              controller.filterBy,
            ),

            // const SizedBox(height: 32),

            // SizedBox(
            //   width: double.infinity,
            //   child: FilledButton(
            //     style: ButtonStyle(
            //       shape: WidgetStatePropertyAll(
            //         RoundedRectangleBorder(
            //           borderRadius: BorderRadiusGeometry.circular(12),
            //         ),
            //       ),
            //     ),
            //     onPressed: () => {},
            //     child: const Text('Show Results'),
            //   ),
            // ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HistoryView'), centerTitle: true),
      body: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(8, 0, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () => _showFilter(context),
              label: Text(
                'Filter',
                style: TextStyle(color: Colors.grey.shade800),
              ),
              icon: Icon(Icons.filter_alt, color: Colors.grey.shade800),
              style: ButtonStyle(),
            ),

            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.history.length,
                itemBuilder: (_, i) {
                  final transaction = controller.history[i];

                  final icon = switch (transaction.type) {
                    TransactionType.income => Icons.arrow_downward_rounded,
                    TransactionType.expense => Icons.arrow_downward_rounded,
                    TransactionType.transfer => Icons.arrow_downward_rounded,
                  };

                  final accent = switch (transaction.type) {
                    TransactionType.income => AppColors.income,
                    TransactionType.expense => AppColors.expense,
                    TransactionType.transfer => AppColors.transfer,
                  };

                  return Dismissible(
                    key: Key(transaction.id.toString()),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) => _showConfirmDialog(),
                    onDismissed: (_) =>
                        controller.deleteTransaction(transaction.id),
                    child: GestureDetector(
                      onTap: () => Get.toNamed(
                        '/edit-transaction',
                        arguments: transaction,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: accent),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withAlpha(100),
                              blurRadius: 0.5,
                              spreadRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(icon, color: accent),

                              const SizedBox(width: 15),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text(transaction.title)],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> _showConfirmDialog() async {
  final result = await Get.dialog<bool>(
    CupertinoAlertDialog(
      title: const Text('Delete'),
      content: const Text('Delete this wallet'),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Yes', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('No'),
        ),
      ],
    ),
  );
  return result ?? false;
}
