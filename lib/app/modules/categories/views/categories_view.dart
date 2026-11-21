import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/components/section_options.dart';
import 'package:money_tracker/app/data/repos/category_repo.dart';
import 'package:money_tracker/app/data/schemas/categories_schema.dart';
import 'package:money_tracker/app/helper/category_icon.dart';

import '../controllers/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

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
              ['Name', 'Created'],
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
              ['All', 'Income', 'Expense'],
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
      appBar: AppBar(
        title: const Text('Categories'),
        // actions: [
        //   TextButton.icon(
        //     onPressed: () => Get.toNamed('/add-category'),
        //     icon: const Icon(
        //       Icons.add_rounded,
        //       color: Colors.blue,
        //       fontWeight: FontWeight.bold,
        //     ),
        //     iconAlignment: IconAlignment.end,
        //     label: const Text('Add Category'),
        //   ),
        // ],
      ),

      body: Obx(
        () => Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    onPressed: () => Get.toNamed('add-category'),
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

              const SizedBox(height: 4),

              Expanded(
                child: controller.categoryList.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          final c = controller.categoryList[index];

                          final isIncome = c.type == CategoryType.income;
                          final accent = isIncome ? Colors.teal : Colors.orange;

                          return Dismissible(
                            key: Key(c.id.toString()),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) => _showConfirmDialog(),
                            onDismissed: (_) => controller.deleteCategory(c.id),
                            child: GestureDetector(
                              onTap: () =>
                                  Get.toNamed('/edit-category', arguments: c),
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
                                      Icon(
                                        iconFromKey(c.icon),
                                        color: c.iconColor == null
                                            ? Colors.black
                                            : Color(c.iconColor!),
                                      ),

                                      const SizedBox(width: 15),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(c.title),

                                          Text(
                                            controller.getCategoryType(c.type),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  c.type == CategoryType.income
                                                  ? Colors.teal
                                                  : Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        shrinkWrap: true,
                        itemCount: controller.categoryList.length,
                      )
                    : Center(child: const Text('Categories Empty')),
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
