import 'package:car_care/all_export.dart';
import 'package:flutter/material.dart';

ThemeData light({Color color = AppColors.primaryColor}) => ThemeData(
  fontFamily: 'InterMedium',
  primaryColor: AppColors.primaryColor,
  secondaryHeaderColor: AppColors.blackColor,
  disabledColor: AppColors.grayColor,
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF4F6FB),
  hintColor: AppColors.hintColor,
  cardColor: AppColors.whiteColor,
  dividerColor: const Color(0xFFE7EAF1),
  shadowColor: AppColors.shadowColor.withValues(alpha: 0.18),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.primaryColor,
    unselectedItemColor: const Color(0xFF8A92A3),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF9FBFF),
    hintStyle: TextStyle(color: AppColors.hintColor, fontSize: 16),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    enabledBorder: enableBorder(),
    focusedBorder: focusedBorder(),
    errorBorder: errorBorder(),
  ),
  textTheme: ThemeData.light().textTheme.copyWith(
    bodyLarge: ThemeData.light().textTheme.bodyLarge?.copyWith(
      color: AppColors.textColor,
    ),
    bodyMedium: ThemeData.light().textTheme.bodyMedium?.copyWith(
      color: AppColors.subTextColor,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: color),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  colorScheme: ColorScheme.light(
    primary: color,
    secondary: AppColors.brandWarm,
  ).copyWith(surface: const Color(0xFFF8FAFD), error: const Color(0xFFE84D4F)),
);

OutlineInputBorder enableBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: AppColors.borderColor),
  );
}

OutlineInputBorder focusedBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: AppColors.primaryColor.withValues(alpha: 0.7),
    ),
  );
}

OutlineInputBorder errorBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.red),
  );
}
