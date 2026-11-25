import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_transfer_transaction_controller.dart';

class AddTransferTransactionView
    extends GetView<AddTransferTransactionController> {
  const AddTransferTransactionView({super.key});

  Future<void> _onBack() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: const Center(
        child: Text(
          'AddTransferTransactionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
