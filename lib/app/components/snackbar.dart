import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(bool isTrue, String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: isTrue ? Colors.blue : Colors.red,
  );
}
