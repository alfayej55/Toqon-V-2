import 'package:car_care/extension/contaxt_extension.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import '../base/glass_container.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final double? width;
  const CustomCard({super.key, required this.child, this.margin, this.width});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: width ?? context.screenWidth,
      margin: margin ?? EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(Dimensions.radius),
      borderRadius: BorderRadius.circular(16),
      color:
          Get.isDarkMode
              ? const Color(0xB31A202B)
              : Colors.white.withValues(alpha: 0.88),
      child: child,
    );
  }
}
