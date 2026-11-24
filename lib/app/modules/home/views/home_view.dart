import 'dart:math' as math;
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
                          onTap: () => Get.toNamed('/add-income-transaction'),
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
                          onTap: () => Get.toNamed('/add-expense-transaction'),
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
                          onTap: () => Get.toNamed('/add-transfer-transaction'),
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

      bottomNavigationBar: ClipPath(
        clipper: const _NotchClipper(),
        child: Material(
          color: Colors.blueGrey.shade900,
          child: SizedBox(
            height: 65,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _iconNavigationButton(0, CupertinoIcons.home),
                  _iconNavigationButton(1, Icons.wallet_rounded),
                  const SizedBox(width: 48),
                  _iconNavigationButton(2, Icons.category_rounded),
                  _iconNavigationButton(3, Icons.history_rounded),
                ],
              ),
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

// import 'dart:math' as math;

class _NotchClipper extends CustomClipper<Path> {
  const _NotchClipper({
    this.radius = 36, // radius FAB 28 + jarak 8, dipakai merata di semua sisi
    this.fillet = 14, // kehalusan sudut pertemuan notch dan sisi atas
  });

  final double radius;
  final double fillet;

  @override
  Path getClip(Size size) {
    final cx = size.width / 2;
    final r = radius;
    final f = fillet;

    // pusat fillet ada di (cx ± dx, f), bersinggungan dengan garis y=0
    // dan lingkaran notch (pusat (cx, 0), radius r)
    final dx = math.sqrt(r * r + 2 * r * f);

    // titik singgung fillet dengan lingkaran notch
    final tx = dx * r / (r + f);
    final ty = f * r / (r + f);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(cx - dx, 0)
      // fillet kiri
      ..arcToPoint(
        Offset(cx - tx, ty),
        radius: Radius.circular(f),
        clockwise: true,
      )
      // lingkaran notch, pusatnya sama dengan pusat FAB
      ..arcToPoint(
        Offset(cx + tx, ty),
        radius: Radius.circular(r),
        clockwise: false,
      )
      // fillet kanan
      ..arcToPoint(
        Offset(cx + dx, 0),
        radius: Radius.circular(f),
        clockwise: true,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(_NotchClipper old) =>
      old.radius != radius || old.fillet != fillet;
}
