

import 'package:car_care/extension/contaxt_extension.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.onTap,
    required this.text,
    this.textStyle,
    this.padding = EdgeInsets.zero,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 8.0,
    this.foregroundColor,
    this.loading = false,
  });

  final Function() onTap;
  final String text;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderSide? borderColor;
  final double borderRadius;
  final Color? foregroundColor;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextButton(
        onPressed: loading ? () {} : onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 5),
          backgroundColor: backgroundColor ?? Get.theme.cardColor,
          side: borderColor ?? BorderSide(color: AppColors.borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          foregroundColor: foregroundColor ?? AppColors.borderColor,
          minimumSize: Size(width ?? context.screenWidth, height ?? 53), // Default height is 53, adjust as needed
        ),
        child: loading
            ? SizedBox(
          height: 20,
          width: 20,
          child: const CircularProgressIndicator(color: Colors.white),
        )
            : Text(
          text,
          style: textStyle ?? AppStyles.h6(),
        ),
      ),
    );
  }
}