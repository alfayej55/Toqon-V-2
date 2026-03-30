import 'package:flutter/cupertino.dart';

class AppColors {
  // 2026 premium brand palette (logo-inspired, softer and more refined).
  static const Color brandDeep = Color(0xFF6A1838);
  static const Color brandPrimary = Color(0xFFC83E32);
  static const Color brandWarm = Color(0xFFF08E2F);
  static const Color brandHighlight = Color(0xFFF6A24C);

  static const List<Color> brandGradient = [brandDeep, brandPrimary, brandWarm];

  static const Color primaryColor = brandPrimary;
  static const Color backgroundColor = Color(0xFFF6F7FA);
  static const Color secendaryColor = Color(0xFF1FA060);
  static const Color cardColor = Color(0xFF1E2128);
  static const Color cardLightColor = Color(0xFF2B303A);
  static Color borderColor = const Color(0xFFB2BAC8).withValues(alpha: 0.5);
  static const Color textColor = Color(0xFF111318);
  static const Color subTextColor = Color(0xFF5B6474);
  static const Color hintColor = Color(0xFF9EA7B8);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color greyColor = Color(0xFFB5B5B5);
  static Color fillColor = const Color(0xFFF8FAFD);
  static const Color dividerColor = Color(0xFF3D4451);
  static const Color shadowColor = Color(0xFF8B94A6);
  static const Color bottomBarColor = Color(0xFF14171D);
  static const Color blackColor = Color(0xFF000000);
  static const Color grayColor = Color(0xFF8D95A5);
  static const Color yelloColor = Color(0xFFFFCE0A);

  static BoxShadow shadow = BoxShadow(
    blurRadius: 4,
    spreadRadius: 0,
    color: shadowColor.withValues(alpha: 0.25),
    offset: const Offset(0, 2),
  );
}
