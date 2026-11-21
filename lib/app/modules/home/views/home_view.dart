import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/modules/categories/views/categories_view.dart';
import 'package:money_tracker/app/modules/funds/views/funds_view.dart';
import 'package:money_tracker/app/modules/history/views/history_view.dart';

import '../controllers/home_controller.dart';

class Views extends GetView<HomeController> {
  const Views({super.key});

  static const List<Widget> _views = [
    HomeView(),
    FundsView(),
    CategoriesView(),
    HistoryView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () =>
              IndexedStack(index: controller.pageIndex.value, children: _views),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(16, 0, 16, 8),
        child: Obx(
          () => Container(
            height: 65,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _iconNavigationButton(0, CupertinoIcons.home),
                _iconNavigationButton(1, Icons.wallet_rounded),
                _iconNavigationButton(2, Icons.category_rounded),
                _iconNavigationButton(3, Icons.history_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconNavigationButton(int index, IconData icon) {
    final isSelected = controller.pageIndex.value == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => controller.pageIndex.value = index,
      child: SizedBox(
        height: 65,
        width: 56,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, isSelected ? -5 : 0, 0),
          child: AnimatedScale(
            scale: isSelected ? 1.1 : 1,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          ),
        ),
      ),
    );
  }
}

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomeView'), centerTitle: true),
      body: const Center(
        child: Text('HomeView is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
