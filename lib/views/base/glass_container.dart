import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double blur;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding,
    this.margin,
    this.color,
    this.blur = 14,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color:
                    isDark
                        ? Colors.black.withValues(alpha: 0.12)
                        : Colors.black.withValues(alpha: 0.08),
                blurRadius: isDark ? 10 : 16,
                offset: Offset(0, isDark ? 2 : 6),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color:
                  color ??
                  (isDark ? const Color(0xB0212631) : const Color(0xD9FFFFFF)),
              border:
                  border ??
                  Border.all(
                    color:
                        isDark
                            ? Colors.white.withValues(alpha: 0.10)
                            : Colors.white.withValues(alpha: 0.75),
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
