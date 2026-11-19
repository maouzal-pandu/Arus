import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget formInputFieldCol(String label, Widget inputField) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    inputField,
  ],
);

InputDecoration formInputFieldDecoration() => InputDecoration(
  isDense: true,
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
);

Widget formInputTypeRow<T>(
  Rx<T> selected,
  List<T> values,
  List<String> labels, {
  List<IconData>? icons,
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

        return Expanded(
          child: isSelected
              ? FilledButton.icon(
                  onPressed: () => onTap,
                  label: Text(label),
                  icon: icons == null ? const SizedBox.shrink() : Icon(icon),
                )
              : OutlinedButton.icon(
                  onPressed: onTap,
                  label: Text(label),
                  icon: icons == null ? const SizedBox.shrink() : Icon(icon),
                ),
        );
      }),
    ),
  );
}
