import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/components/data_form.dart';
import 'package:money_tracker/app/components/skeleton_shimmer_box.dart';
import 'package:money_tracker/app/core/theme/app_colors.dart';
import 'package:money_tracker/app/data/database.dart';
import 'package:money_tracker/app/data/schemas/funds_schema.dart';
import 'package:money_tracker/app/helper/category_icon.dart';
import 'package:money_tracker/app/helper/rupiah_formatter.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/add_income_transaction_controller.dart';

class AddIncomeTransactionView extends GetView<AddIncomeTransactionController> {
  const AddIncomeTransactionView({super.key});

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
        if (didPop) {
          return;
        }

        _onBack();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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

        body: Obx(() {
          if (controller.isLoading.value) {
            return AddIncomeSkeleton();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Form(
                key: controller.formK,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentGeometry.center,
                      child: Text(
                        'Add Income Transaction',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    formInputFieldCol(
                      'Title',
                      TextFormField(
                        controller: controller.titleC,
                        decoration: formInputFieldDecoration(),
                        maxLength: 100,
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
                          final v = value!.trim();

                          if (v.isEmpty) {
                            return 'This field cannot be empty';
                          }

                          return null;
                        },
                      ),
                    ),

                    Obx(() {
                      final selected = controller.fund;

                      return formInputFieldCol(
                        'Fund',
                        DropdownMenuFormField<Fund>(
                          menuStyle: MenuStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(8),
                                side: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          alignmentOffset: Offset(0, 5),
                          initialSelection: controller.funds[0],
                          onSelected: (value) => controller.fund.value = value,
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          decorationBuilder: (context, controller) {
                            return InputDecoration(
                              prefixIcon: buildFundType(selected.value!.type),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );
                          },
                          dropdownMenuEntries: List.generate(
                            controller.funds.length,
                            (index) {
                              final f = controller.funds[index];

                              final bgColor = index.isOdd
                                  ? Colors.grey.shade100
                                  : Colors.white;

                              final icon = f.type == FundType.cash
                                  ? Icon(
                                      Icons.payments_rounded,
                                      color: Colors.green,
                                    )
                                  : Icon(Icons.credit_card, color: Colors.blue);

                              final type = f.type == FundType.cash
                                  ? Text(
                                      'Cash',
                                      style: TextStyle(
                                        color: AppColors.cash,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    )
                                  : Text(
                                      'Cashless',
                                      style: TextStyle(
                                        color: AppColors.cashless,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );

                              return DropdownMenuEntry<Fund>(
                                value: f,
                                label: f.title,
                                leadingIcon: icon,
                                trailingIcon: type,
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    bgColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    Obx(() {
                      final selected = controller.category;

                      return formInputFieldCol(
                        'Category',
                        DropdownMenuFormField<Category>(
                          menuStyle: MenuStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(8),
                                side: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          alignmentOffset: Offset(0, 5),
                          initialSelection: controller.categories[0],
                          onSelected: (value) =>
                              controller.category.value = value,
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          decorationBuilder: (context, controller) {
                            return InputDecoration(
                              prefixIcon: buildCategoryType(selected.value!),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );
                          },
                          dropdownMenuEntries: List.generate(
                            controller.categories.length,
                            (index) {
                              final c = controller.categories[index];
                              final bgColor = index.isOdd
                                  ? Colors.grey.shade100
                                  : Colors.white;
                              final icon =
                                  iconFromKey(c.icon) ?? Icons.category_rounded;
                              final iconColor = c.iconColor != null
                                  ? Color(c.iconColor!)
                                  : Colors.grey;

                              return DropdownMenuEntry<Category>(
                                value: c,
                                label: c.title,
                                leadingIcon: Icon(icon, color: iconColor),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    bgColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    formInputFieldCol(
                      'Description',
                      TextFormField(
                        controller: controller.descriptionC,
                        decoration: formInputFieldDecoration(isOptional: true),
                        minLines: 3,
                        maxLines: 5,
                        maxLength: 500,
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
                          final v = value!.trim();

                          if (v.isEmpty) {
                            return 'This field cannot be empty';
                          }

                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    formInputFieldCol(
                      'Amount',
                      TextFormField(
                        controller: controller.amountC,
                        decoration: formInputFieldDecoration(),
                        keyboardType: TextInputType.numberWithOptions(),
                        inputFormatters: [InputRupiahFormatter()],
                        validator: (value) {
                          final v = int.tryParse(value!.replaceAll('.', ''));

                          if (value.isEmpty) {
                            return 'This field cannot be empty';
                          } else if (v! < 0) {
                            return 'Invalid input value';
                          }

                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    Align(
                      alignment: AlignmentGeometry.centerRight,
                      child: FilledButton(
                        onPressed: controller.recordTransaction,
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
                        child: const Text(
                          'Record',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 128),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AddIncomeSkeleton extends StatelessWidget {
  const AddIncomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentGeometry.center,
              child: SkeletonBox(height: 20, width: 300),
            ),
            SizedBox(height: 32),

            // Title
            SkeletonBox(height: 14, width: 60),
            SizedBox(height: 8),
            SkeletonBox(height: 52),
            SizedBox(height: 24),

            // Fund
            SkeletonBox(height: 14, width: 50),
            SizedBox(height: 8),
            SkeletonBox(height: 52),
            SizedBox(height: 24),

            // Category
            SkeletonBox(height: 14, width: 50),
            SizedBox(height: 8),
            SkeletonBox(height: 52),
            SizedBox(height: 24),

            // Description
            SkeletonBox(height: 14, width: 90),
            SizedBox(height: 8),
            SkeletonBox(height: 120),
          ],
        ),
      ),
    );
  }
}
