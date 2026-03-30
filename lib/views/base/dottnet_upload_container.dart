import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:car_care/all_export.dart';
class DottnetUploadContainer extends StatelessWidget {

  const DottnetUploadContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return  DottedBorder(
      options: RectDottedBorderOptions(
          dashPattern: [10, 5],
          strokeWidth: 1,
          padding: EdgeInsets.all(16),
          color: AppColors.primaryColor.withValues(alpha: 0.5)
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upload Icon
            SvgPicture.asset(
              AppIcons.fileIcon,
              colorFilter: ColorFilter.mode(Get.theme.textTheme.bodyMedium!.color!, BlendMode.srcIn),
              width: 32,
              height: 32,
            ),
            const SizedBox(height: 12),
            Text(
              "Drop File Or Browse",
              style: AppStyles.h5(color: Get.theme.textTheme.bodyMedium!.color),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              "Format: .jpg, .png & Max Size 20MB",
              style: AppStyles.h6(color: Get.theme.textTheme.bodyMedium!.color),
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
    );

  }
}
