import 'package:flutter/material.dart';

Widget buildChip({
  required String label,
  required bool isSelected,
  required VoidCallback callback,
}) => ChoiceChip(
  label: Text(label),
  selected: isSelected,
  onSelected: (_) => callback,
);
