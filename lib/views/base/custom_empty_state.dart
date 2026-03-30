import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:car_care/all_export.dart';

class CustomEmptyState extends StatelessWidget {
  final String? icon;
  final String? image;
  final String title;
  final String? subtitle;
  final double? iconSize;
  final Widget? actionButton;

  const CustomEmptyState({
    super.key,
    this.icon,
    this.image,
    this.title = 'No Data Found',
    this.subtitle,
    this.iconSize = 80,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon or Image
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.brandDeep.withValues(alpha: 0.1),
                      AppColors.brandPrimary.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: SvgPicture.asset(
                  icon!,
                  height: iconSize,
                  width: iconSize,
                  colorFilter: ColorFilter.mode(
                    AppColors.primaryColor.withValues(alpha: 0.7),
                    BlendMode.srcIn,
                  ),
                ),
              )
            else if (image != null)
              Image.asset(image!, height: iconSize! + 40, width: iconSize! + 40)
            else
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.brandDeep.withValues(alpha: 0.1),
                      AppColors.brandPrimary.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.inbox_outlined,
                  size: iconSize,
                  color: AppColors.primaryColor.withValues(alpha: 0.7),
                ),
              ),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: AppStyles.h2(fontFamily: 'OutfitBold'),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppStyles.h5(color: AppColors.grayColor),
                textAlign: TextAlign.center,
              ),
            ],

            // Action Button
            if (actionButton != null) ...[
              const SizedBox(height: 24),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
}
