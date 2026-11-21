import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/components/data_form.dart';
import 'package:money_tracker/app/data/schemas/funds_schema.dart';
import 'package:money_tracker/app/helper/rupiah_formatter.dart';

import '../controllers/add_fund_controller.dart';

class AddFundView extends GetView<AddFundController> {
  const AddFundView({super.key});

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

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: controller.formK,
              child: Column(
                children: [
                  Text(
                    'Add Fund',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 32),

                  formInputFieldCol(
                    'Title',
                    TextFormField(
                      controller: controller.titleC,
                      decoration: formInputFieldDecoration(),
                      cursorHeight: 21.5,
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
                        'Type',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      formInputTypeRow<FundType>(
                        controller.type,
                        FundType.values,
                        ['Cash', 'Cashless'],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  formInputFieldCol(
                    'Amount',
                    TextFormField(
                      controller: controller.amountC,
                      decoration: formInputFieldDecoration(),
                      inputFormatters: [InputRupiahFormatter()],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nominal wajib diisi';
                        }
                        final nominal = int.tryParse(value.replaceAll('.', ''));
                        if (nominal == null) return 'Nominal tidak valid';
                        if (nominal < 0) return 'Nominal tidak boleh negatif';
                        return null;
                      },
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
                      onPressed: () => controller.createFund(),
                      child: const Text(
                        'Create',
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
