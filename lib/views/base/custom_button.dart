import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../../utils/app_colors.dart';
import '../../utils/style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.color,
    this.textStyle,
    this.padding = EdgeInsets.zero,
    required this.onTap,
    required this.text,
    this.loading = false,
    this.width,
    this.height,
    this.borderRadius,
  });
  final Function() onTap;
  final String text;
  final bool loading;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final BorderRadius resolvedRadius =
        borderRadius ?? BorderRadius.circular(16);
    final bool useGradient = color == null;

    return Padding(
      padding: padding,
      child: ClipRRect(
        borderRadius: resolvedRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: resolvedRadius,
              gradient:
                  useGradient
                      ? const LinearGradient(
                        colors: AppColors.brandGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                      : null,
              color: useGradient ? null : color!.withValues(alpha: 0.92),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandPrimary.withValues(alpha: 0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: loading ? () {} : onTap,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: resolvedRadius),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                elevation: 0,
                minimumSize: Size(width ?? Get.width, height ?? 53),
              ),
              child:
                  loading
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                      : Text(
                        text,
                        style:
                            textStyle ??
                            AppStyles.h3(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
