import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/components/data_form.dart';
import 'package:money_tracker/app/core/theme/app_colors.dart';
import 'package:money_tracker/app/data/schemas/categories_schema.dart';
import 'package:money_tracker/app/helper/category_icon.dart';

import '../controllers/edit_category_controller.dart';

class EditCategoryView extends GetView<EditCategoryController> {
  const EditCategoryView({super.key});

  static const _iconColors = <Color>[
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
  ];

  Future<void> _onBack() async {
    if (await controller.showDiscardChangesDialog()) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _onBack();
      },
      child: Scaffold(
        appBar: AppBar(
          // title: const Text('AddCategoryView'),
          automaticallyImplyLeading: false,
          actionsPadding: EdgeInsets.only(right: 8),
          actions: [
            GestureDetector(
              onTap: _onBack,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                padding: EdgeInsets.all(4),
                child: Center(
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: controller.formK,
              child: Column(
                children: [
                  Text(
                    'Update Category',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 32),

                  formInputFieldCol(
                    'Title',
                    TextFormField(
                      controller: controller.titleC,
                      decoration: formInputFieldDecoration(),
                      maxLength: 50,
                      buildCounter:
                          (
                            context, {
                            required currentLength,
                            required isFocused,
                            required maxLength,
                          }) => Text(
                            '$currentLength/$maxLength',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                      validator: (value) {
                        final title = value?.trim();

                        if (title!.isEmpty) {
                          return 'Field cannot be empty';
                        }

                        return null;
                      },
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      const Text(
                        'Category Type',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      formInputTypeRow<CategoryType>(
                        controller.type,
                        CategoryType.values,
                        ['Income', 'Expense'],
                        colors: [AppColors.income, AppColors.expense],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: formInputFieldCol(
                      'Icon',
                      MenuAnchor(
                        alignmentOffset: Offset(0, 5),
                        style: MenuStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(16),
                              side: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        menuChildren: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: SizedBox(
                              width: 260,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Color',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Obx(
                                    () => Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        for (final c in _iconColors)
                                          GestureDetector(
                                            onTap: () =>
                                                controller.iconColor.value = c,
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: c,
                                                shape: BoxShape.circle,
                                                border:
                                                    controller
                                                            .iconColor
                                                            .value ==
                                                        c
                                                    ? Border.all(
                                                        width: 3,
                                                        color: Colors.white,
                                                      )
                                                    : null,
                                                boxShadow:
                                                    controller
                                                            .iconColor
                                                            .value ==
                                                        c
                                                    ? [
                                                        BoxShadow(
                                                          color: c,
                                                          blurRadius: 4,
                                                        ),
                                                      ]
                                                    : null,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  const Divider(height: 24),

                                  const Text(
                                    'Icon',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 180,
                                    ),
                                    child: SingleChildScrollView(
                                      primary: false,
                                      child: Obx(
                                        () => Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            for (final i
                                                in categoryIcons.entries)
                                              InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                onTap: () {
                                                  controller.icon.value == i.key
                                                      ? controller.icon.value =
                                                            null
                                                      : controller.icon.value =
                                                            i.key;
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          controller
                                                                  .icon
                                                                  .value ==
                                                              i.key
                                                          ? Colors.blue
                                                          : Colors
                                                                .grey
                                                                .shade300,
                                                      width:
                                                          controller
                                                                  .icon
                                                                  .value ==
                                                              i.key
                                                          ? 2
                                                          : 1,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    i.value,
                                                    color:
                                                        controller
                                                            .iconColor
                                                            .value ??
                                                        Colors.black,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        builder: (context, menuController, child) {
                          return GestureDetector(
                            onTap: () => menuController.isOpen
                                ? menuController.close()
                                : menuController.open(),
                            child: Container(
                              height: 45,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    controller.icon.value == null
                                        ? const SizedBox.shrink()
                                        : Icon(
                                            categoryIcons[controller
                                                .icon
                                                .value],
                                            color:
                                                controller.iconColor.value ??
                                                Colors.black,
                                          ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: FilledButton(
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(
                          EdgeInsetsDirectional.symmetric(horizontal: 40),
                        ),
                        backgroundColor: WidgetStatePropertyAll(Colors.blue),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () => controller.editCategory(),
                      child: const Text(
                        'Update',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
