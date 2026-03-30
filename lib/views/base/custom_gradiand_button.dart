import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'dart:ui';

class CustomGradientButton extends StatelessWidget {
  const CustomGradientButton({
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
    this.showGlow = true,
  });
  final Function() onTap;
  final String text;
  final bool loading;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? color;
  final bool showGlow;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: width ?? MediaQuery.of(context).size.width,
        height: height ?? 45,
        child: InkWell(
          onTap: loading ? null : onTap, // null disables ripple + tap
          borderRadius: borderRadius ?? BorderRadius.circular(14),
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: AppColors.brandGradient,
                  ),
                  boxShadow:
                      showGlow
                          ? [
                            BoxShadow(
                              color: AppColors.brandPrimary.withValues(
                                alpha: 0.25,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                          : null,
                  border: Border.all(
                    color: AppColors.whiteColor.withValues(alpha: 0.22),
                  ),
                ),
                child: Center(
                  child:
                      loading
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
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
        ),
      ),
    );
  }
}
