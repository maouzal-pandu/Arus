import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget amountFundRow(int amount) {
  final format = NumberFormat.decimalPattern('id_ID');
  final formattedAmount = format.format(amount);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Rp.', style: TextStyle(color: Colors.grey, fontSize: 10)),
      Text(formattedAmount),
    ],
  );
}
