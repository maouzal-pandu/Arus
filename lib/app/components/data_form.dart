import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_tracker/app/data/database.dart';
import 'package:money_tracker/app/data/schemas/funds_schema.dart';
import 'package:money_tracker/app/helper/category_icon.dart';

Widget formInputFieldCol(String label, Widget inputField) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(label, style: TextStyle()),
    const SizedBox(height: 8),
    inputField,
  ],
);

InputDecoration formInputFieldDecoration({bool isOptional = false}) =>
    InputDecoration(
      // contentPadding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey),
      ),
      helper: isOptional
          ? const Text(
              'Optional',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          : null,
    );

Widget formInputTypeRow<T>(
  Rx<T> selected,
  List<T> values,
  List<String> labels, {
  List<IconData>? icons,
  List<Color>? colors,
}) {
  assert(values.length == labels.length);

  return Obx(
    () => Row(
      spacing: 8,
      children: List.generate(values.length, (i) {
        final isSelected = selected.value == values[i];
        void onTap() => selected.value = values[i];
        final label = labels[i];
        final icon = icons == null ? null : icons[i];
        final color = colors != null ? colors[i] : null;

        return Expanded(
          child: isSelected
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  transform: Matrix4.translationValues(
                    0,
                    isSelected ? -5 : 0,
                    0,
                  ),
                  child: FilledButton.icon(
                    onPressed: () => onTap,
                    label: Text(
                      label,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    icon: icons == null ? const SizedBox.shrink() : Icon(icon),
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        color ?? Colors.deepPurple,
                      ),
                    ),
                  ),
                )
              : AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  transform: Matrix4.translationValues(
                    0,
                    isSelected ? -3 : 0,
                    0,
                  ),
                  child: FilledButton.icon(
                    onPressed: onTap,
                    label: Text(
                      label,
                      style: TextStyle(
                        color: colors != null ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: icons == null ? const SizedBox.shrink() : Icon(icon),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        color ?? Colors.grey.shade300,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      }),
    ),
  );
}

Widget buildFundType(FundType t) => t == FundType.cash
    ? const Icon(Icons.payments_rounded, color: Colors.green)
    : const Icon(Icons.credit_card, color: Colors.blue);

Widget buildCategoryType(Category c) {
  final color = c.iconColor != null ? Color(c.iconColor!) : Colors.grey;
  final icon = iconFromKey(c.icon) ?? Icons.category_rounded;

  return Icon(icon, color: color);
}
