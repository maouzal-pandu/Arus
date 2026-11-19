import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget sectionOption<T>(
  String sectionTitle,
  List<String> options,
  List<T> values,
  Rx<T> selected,
) {
  final double hwTrail = 18;

  return Obx(
    () => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),

        ...List.generate(options.length, (i) {
          final isSelected = selected.value == values[i];
          void onTap() => selected.value = values[i];

          return GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: SizedBox(
                width: double.infinity,
                height: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(options[i], style: TextStyle(fontSize: 13)),
                    ),
                    !isSelected
                        ? Container(
                            height: hwTrail,
                            width: hwTrail,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: Colors.grey),
                            ),
                          )
                        : Container(
                            height: hwTrail,
                            width: hwTrail,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: Colors.blue, width: 5),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 8),
      ],
    ),
  );
}
