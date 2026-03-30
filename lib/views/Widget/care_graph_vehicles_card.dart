import 'package:car_care/models/vahical_model.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CareGraphVehiclesCard extends StatelessWidget {
  final VehiclesModel vehiclesModel;

  const CareGraphVehiclesCard({super.key, required this.vehiclesModel});

  @override
  Widget build(BuildContext context) {
    final bool hasImage = vehiclesModel.vehicleImages.isNotEmpty;
    final serviceCount =
        (vehiclesModel.nuumberOfService is int)
            ? vehiclesModel.nuumberOfService as int
            : int.tryParse(vehiclesModel.nuumberOfService.toString()) ?? 0;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color:
            Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.9),
        border: Border.all(
          color: AppColors.borderColor.withValues(
            alpha: Get.isDarkMode ? 0.28 : 0.4,
          ),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Get.isDarkMode
                    ? Colors.black.withValues(alpha: 0.1)
                    : const Color(0x190B1325),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color:
                  Get.isDarkMode
                      ? const Color(0x2EF08E2F)
                      : const Color(0x1AF08E2F),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child:
                hasImage
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CustomNetworkImage(
                        imageUrl: vehiclesModel.vehicleImages.first,
                        width: 66,
                        height: 66,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    )
                    : Icon(
                      Icons.directions_car_rounded,
                      color: AppColors.brandPrimary,
                      size: 30,
                    ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehiclesModel.vehicleName.isEmpty
                      ? vehiclesModel.manufacturer
                      : vehiclesModel.vehicleName,
                  style: AppStyles.h2(fontFamily: 'InterSemiBold'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  '${vehiclesModel.yearOfManufacture == 0 ? '' : vehiclesModel.yearOfManufacture} '
                  '${vehiclesModel.manufacturer} ${vehiclesModel.model}',
                  style: AppStyles.h4(
                    color: Get.theme.textTheme.bodyMedium!.color?.withValues(
                      alpha: 0.9,
                    ),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color:
                        Get.isDarkMode
                            ? Colors.white.withValues(alpha: 0.07)
                            : const Color(0xFFF3F5FB),
                  ),
                  child: Text(
                    vehiclesModel.registrationNumber,
                    style: AppStyles.h6(
                      color: Get.theme.textTheme.bodyMedium!.color,
                      fontFamily: 'InterSemiBold',
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.brandGradient,
              ),
            ),
            child: Column(
              children: [
                SvgPicture.asset(
                  AppIcons.serviceNoteIcon,
                  height: 14,
                  width: 14,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$serviceCount',
                  style: AppStyles.h4(
                    color: Colors.white,
                    fontFamily: 'InterBold',
                  ),
                ),
                Text(
                  'LOGS',
                  style: AppStyles.h6(
                    color: Colors.white.withValues(alpha: 0.85),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
