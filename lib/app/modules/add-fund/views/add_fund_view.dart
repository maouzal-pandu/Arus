import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/components/data_form.dart';
import 'package:money_tracker/app/data/schemas/funds_schema.dart';
import 'package:money_tracker/app/helper/rupiah_formatter.dart';

import '../controllers/add_fund_controller.dart';

class AddFundView extends GetView<AddFundController> {
  const AddFundView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AddFundView'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: controller.formK,
            child: Column(
              children: [
                const SizedBox(height: 32),

                formInputTypeRow<FundType>(controller.type, FundType.values, [
                  'Cash',
                  'Cashless',
                ]),

                const SizedBox(height: 16),

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
                      final title = value?.trim();

                      if (title!.isEmpty) {
                        return 'Field cannot be empty';
                      }

                      return null;
                    },
                  ),
                ),

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

                OutlinedButton(
                  onPressed: () => controller.createFund(),
                  child: const Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
