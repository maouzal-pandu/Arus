import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/core/theme/app_colors.dart';
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
      extendBody: true, // biar konten tembus ke belakang lekukan
      body: Stack(
        children: [
          SafeArea(
            child: Obx(
              () => IndexedStack(
                index: controller.pageIndex.value,
                children: _views,
              ),
            ),
          ),

          // scrim + opsi FAB
          Obx(() {
            final open = controller.isFabOpen.value;

            return IgnorePointer(
              ignoring: !open, // saat tertutup, jangan makan tap
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: controller.toggleFab, // tap di luar = tutup
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(
                          end: controller.isFabOpen.value ? 1.0 : 0.0,
                        ),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        builder: (context, t, _) => ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 2.5 * t,
                              sigmaY: 2.5 * t,
                            ),
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.15 * t),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    // tinggi bar 65 + setengah FAB 28 + jarak 16
                    bottom: 75 + 25,
                    child: AnimatedSlide(
                      offset: Offset(open ? 0.15 : 0, open ? 0 : 1),
                      duration: Duration(milliseconds: open ? 550 : 250),
                      curve: open ? Curves.easeOut : Curves.easeIn,
                      child: AnimatedOpacity(
                        opacity: open ? 1 : 0,
                        duration: Duration(milliseconds: open ? 550 : 250),
                        curve: open ? Curves.easeOut : Curves.easeIn,

                        child: _fabOption(
                          icon: Icons.arrow_downward_rounded,
                          color: AppColors.income,
                          onTap: () => Get.toNamed('/add-expense'),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    // tinggi bar 65 + setengah FAB 28 + jarak 16
                    bottom: 75 + 25,
                    child: AnimatedSlide(
                      offset: Offset(open ? -0.15 : 0, open ? 0 : 1),
                      duration: Duration(milliseconds: open ? 250 : 550),
                      curve: open ? Curves.easeOut : Curves.easeIn,
                      child: AnimatedOpacity(
                        opacity: open ? 1 : 0,
                        duration: Duration(milliseconds: open ? 250 : 550),
                        curve: open ? Curves.easeOut : Curves.easeIn,

                        child: _fabOption(
                          icon: Icons.arrow_upward_rounded,
                          color: AppColors.expense,
                          onTap: () => Get.toNamed('/add-expense'),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    // tinggi bar 65 + setengah FAB 28 + jarak 16
                    bottom: 75 + 70,
                    child: AnimatedSlide(
                      offset: Offset(0, open ? 0 : 2),
                      duration: const Duration(milliseconds: 400),
                      curve: open ? Curves.easeOut : Curves.easeIn,
                      child: AnimatedOpacity(
                        opacity: open ? 1 : 0,
                        duration: const Duration(milliseconds: 400),
                        curve: open ? Curves.easeOut : Curves.easeIn,

                        child: _fabOption(
                          icon: Icons.swap_vert_rounded,
                          color: AppColors.transfer,
                          onTap: () => Get.toNamed('/add-expense'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),

      floatingActionButton: Obx(() {
        final isOpen = controller.isFabOpen.value;
        return TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: isOpen ? Colors.red : Colors.blue),
          duration: const Duration(milliseconds: 300),
          builder: (context, color, child) => FloatingActionButton(
            onPressed: controller.toggleFab,
            backgroundColor: color,
            shape: const CircleBorder(),
            child: child,
          ),
          child: AnimatedRotation(
            turns: isOpen ? 0.125 : 0,
            duration: const Duration(milliseconds: 300),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      }),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey.shade900,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8, // jarak lekukan ke FAB
        height: 65,
        padding: EdgeInsets.zero,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _iconNavigationButton(0, CupertinoIcons.home),
              _iconNavigationButton(1, Icons.wallet_rounded),
              const SizedBox(width: 48), // ruang kosong buat FAB
              _iconNavigationButton(2, Icons.category_rounded),
              _iconNavigationButton(3, Icons.history_rounded),
            ],
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

  Widget _fabOption({
    String? label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        IconButton.filled(
          padding: EdgeInsets.all(10),
          onPressed: () {
            controller.toggleFab(); // tutup dulu
            onTap();
          },
          icon: Icon(icon, fontWeight: FontWeight.bold),
          style: FilledButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            ),
          ),
        ),

        label != null ? Text(label) : const SizedBox.shrink(),
      ],
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
