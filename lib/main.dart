import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:money_tracker/app/data/database.dart';
import 'package:money_tracker/app/data/repos/category_repo.dart';
import 'package:money_tracker/app/data/repos/fund_repo.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  Get.put<CategoryRepo>(CategoryRepo(db: database), permanent: true);
  Get.put<FundRepo>(FundRepo(db: database), permanent: true);

  runApp(
    GetMaterialApp(
      title: "Money Tracker",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(textTheme: GoogleFonts.dmSansTextTheme()),
    ),
  );
}
