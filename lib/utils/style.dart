import 'package:car_care/all_export.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle h1({
    Color? color,
    TextDecoration? decoration,
    String? fontFamily,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color:
          color ?? Get.theme.textTheme.bodyLarge?.color ?? AppColors.textColor,
      fontFamily: fontFamily,
      fontSize: 24,
      decoration: decoration,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight ?? FontWeight.w600,
    );
  }

  static TextStyle h2({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
  }) {
    return TextStyle(
      color:
          color ?? Get.theme.textTheme.bodyLarge?.color ?? AppColors.textColor,
      fontSize: 20,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight ?? FontWeight.w700,
    );
  }

  static TextStyle h3({
    Color? color,
    String? fontFamily,
    FontWeight? fontWeight,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      color:
          color ?? Get.theme.textTheme.bodyLarge?.color ?? AppColors.textColor,
      fontSize: 18,
      fontFamily: fontFamily,
      decoration: decoration,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight ?? FontWeight.w700,
    );
  }

  static TextStyle h4({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return TextStyle(
      fontSize: 16,
      color:
          color ?? Get.theme.textTheme.bodyLarge?.color ?? AppColors.textColor,
      height: height,
      decoration: decoration,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight ?? FontWeight.w600,
    );
  }

  static TextStyle h5({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    String? fontFamily,
    TextDecoration? decoration,
    double? height,
  }) {
    return TextStyle(
      fontSize: 14,
      color:
          color ?? Get.theme.textTheme.bodyLarge?.color ?? AppColors.textColor,
      height: height,
      fontFamily: fontFamily,
      decoration: decoration,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight ?? FontWeight.w500,
    );
  }

  static TextStyle h6({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    String? fontFamily,
    TextDecoration? decoration,
    double? height,
  }) {
    return TextStyle(
      fontSize: 12,
      color:
          color ?? Get.theme.textTheme.bodyLarge?.color ?? AppColors.textColor,
      height: height,
      fontFamily: fontFamily,
      decoration: decoration,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  static TextStyle customSize({
    Color? color,
    required double size,
    String? family,
    double? letterSpacing,
    double? height,
    String? fontFamily,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      fontWeight: fontWeight ?? FontWeight.w400,
      fontFamily: fontFamily,
      color:
          color ?? Get.theme.textTheme.bodyLarge?.color ?? AppColors.textColor,
      fontSize: size,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static BoxShadow get boxShadow => BoxShadow(
    color:
        Get.isDarkMode
            ? Colors.black.withValues(alpha: 0.14)
            : Get.theme.shadowColor.withValues(alpha: 0.16),
    blurRadius: Get.isDarkMode ? 10 : 14,
    offset: Offset(0, Get.isDarkMode ? 3 : 6),
    spreadRadius: 0,
  );
}
