import 'package:flutter/material.dart';
import 'package:student_system/config/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light = ThemeData.light().copyWith(
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),
    cardColor: AppColors.card,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: _appBarTheme(),
  );

  static _appBarTheme() {
    return AppBarTheme(
      titleSpacing: 1,
      iconTheme: IconThemeData(color: AppColors.white),
      backgroundColor: AppColors.primary,
      titleTextStyle: TextStyle(
          color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 24),
    );
  }
}
