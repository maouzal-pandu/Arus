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
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  transform: Matrix4.translationValues(
                    0,
                    isSelected ? -3 : 0,
                    0,
                  ),
                  child: FilledButton.icon(
                    onPressed: () => onTap,
                    label: Text(label),
                    icon: icons == null ? const SizedBox.shrink() : Icon(icon),
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.grey.shade600,
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
                  child: OutlinedButton.icon(
                    onPressed: onTap,
                    label: Text(label, style: TextStyle(color: Colors.black)),
                    icon: icons == null ? const SizedBox.shrink() : Icon(icon),
                    style: ButtonStyle(
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
