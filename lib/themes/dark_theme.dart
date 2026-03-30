import 'package:flutter/material.dart';

import 'package:car_care/utils/app_colors.dart';

ThemeData dark({Color color = AppColors.primaryColor}) => ThemeData(
  fontFamily: 'InterMedium',
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: const Color(0xFF0F1218),
  secondaryHeaderColor: AppColors.blackColor,
  disabledColor: const Color(0xFF7A8499),
  brightness: Brightness.dark,
  hintColor: AppColors.hintColor,
  cardColor: const Color(0xFF1B2029),
  dividerColor: AppColors.dividerColor,
  // Neutral shadow in dark mode to avoid blue halo/glow edges.
  shadowColor: Colors.black.withValues(alpha: 0.30),
  canvasColor: const Color(0xFF121720),
  highlightColor: Colors.transparent,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF171C25),
    hintStyle: TextStyle(color: AppColors.hintColor, fontSize: 16),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    enabledBorder: enableBorder(),
    focusedBorder: focusedBorder(),
    errorBorder: errorBorder(),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: ThemeData.light().textTheme.copyWith(
    bodyLarge: ThemeData.light().textTheme.bodyLarge?.copyWith(
      color: AppColors.whiteColor,
    ),
    bodyMedium: ThemeData.light().textTheme.bodyMedium?.copyWith(
      color: const Color(0xFFC3C8D4),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF11151D),
    selectedItemColor: AppColors.brandWarm,
    unselectedItemColor: const Color(0xFF80889A),
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
  colorScheme: ColorScheme.dark(primary: color, secondary: AppColors.brandWarm)
      .copyWith(surface: const Color(0xFF191E27))
      .copyWith(error: Color(0xFFdd3135)),
);

OutlineInputBorder enableBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: AppColors.hintColor.withValues(alpha: 0.45)),
  );
}

OutlineInputBorder focusedBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: AppColors.brandWarm.withValues(alpha: 0.7)),
  );
}

OutlineInputBorder errorBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.red),
  );
}
