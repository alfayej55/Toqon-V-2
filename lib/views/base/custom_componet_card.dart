import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'glass_container.dart';

class CustomComponetCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final Color? color;

  const CustomComponetCard({
    super.key,
    required this.child,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.all(16),
      margin: margin ?? EdgeInsets.zero,
      borderRadius: BorderRadius.circular(16),
      color:
          color ??
          (Get.isDarkMode
              ? const Color(0xB31A202B)
              : Colors.white.withValues(alpha: 0.9)),
      child: child,
    );
  }
}
