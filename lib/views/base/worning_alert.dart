// lib/widgets/custom_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:car_care/all_export.dart';

import 'custom_gradiand_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final Function() onConfirm;
  final VoidCallback? onCancel;

  const CustomDialog({
    super.key,
    this.title = 'Attention',
    required this.message,
    this.confirmText = 'Continue',
    this.cancelText = 'Close',
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 22),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color:
                isDark
                    ? const Color(0xF21A1F2A)
                    : Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      gradient: const LinearGradient(
                        colors: AppColors.brandGradient,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppIcons.worningIcon,
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: AppStyles.h3(
                        color: isDark ? Colors.white : AppColors.textColor,
                        fontFamily: 'InterSemiBold',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppStyles.h5(
                  color: isDark ? const Color(0xFFD3D9E5) : AppColors.subTextColor,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.26),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Get.back(),
                        child: Text(
                          cancelText!,
                          style: AppStyles.h5(
                            color: isDark ? Colors.white : AppColors.textColor,
                            fontFamily: 'InterSemiBold',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomGradientButton(
                      onTap: () {
                        onConfirm();
                      },
                      text: confirmText!,
                      height: 40,
                      borderRadius: BorderRadius.circular(12),
                      textStyle: AppStyles.h5(
                        color: Colors.white,
                        fontFamily: 'InterSemiBold',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
