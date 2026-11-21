import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/components/currency.dart';
import 'package:money_tracker/app/components/section_options.dart';
import 'package:money_tracker/app/data/repos/fund_repo.dart';
import 'package:money_tracker/app/data/schemas/funds_schema.dart';

import '../controllers/funds_controller.dart';

class FundsView extends GetView<FundsController> {
  const FundsView({super.key});

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
              ['Name', 'Created', 'Amount'],
              SortBy.values,
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
              ['None', 'Cash', 'Cashless'],
              FilterBy.values,
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
      appBar: AppBar(title: const Text('Funds')),
      body: Obx(
        () => Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                  FilledButton.icon(
                    onPressed: () => Get.toNamed('add-fund'),
                    label: const Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: controller.fundsList.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          final f = controller.fundsList[index];

                          String getType() => switch (f.type) {
                            FundType.cash => 'Cash',
                            FundType.digital => 'Cashless',
                          };

                          return Dismissible(
                            key: Key(f.id.toString()),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) => _showConfirmDialog(),
                            onDismissed: (_) => controller.deleteFund(f.id),
                            child: GestureDetector(
                              onTap: () =>
                                  Get.toNamed('/edit-fund', arguments: f),
                              child: Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(f.title),
                                          amountFundRow(f.amount),
                                        ],
                                      ),
                                      Text(
                                        getType(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        shrinkWrap: true,
                        itemCount: controller.fundsList.length,
                      )
                    : Center(child: const Text('Funds Empty')),
              ),
            ],
          ),
        ),
      ),
    );
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
}
