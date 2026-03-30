import 'package:car_care/controllers/care_care_controller.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/svg.dart';

import '../../Widget/care_graph_vehicles_card.dart';

class CareGraphScreen extends StatelessWidget {
  CareGraphScreen({super.key});

  final CareGraphController _carGraphCtrl = Get.put(CareGraphController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: _bgGlow(
              Get.isDarkMode
                  ? const Color(0x146A1838)
                  : const Color(0x12F08E2F),
              250,
            ),
          ),
          Positioned(
            top: 240,
            left: -110,
            child: _bgGlow(
              Get.isDarkMode
                  ? const Color(0x12F08E2F)
                  : const Color(0x106A1838),
              220,
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: ListView(
              children: [
                _topBar(),
                const SizedBox(height: 16),
                _registerCta(context),
                const SizedBox(height: 16),
                _sectionHeader(),
                Obx(() {
                  if (_carGraphCtrl.vehiclesLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(child: CustomPageLoading()),
                    );
                  }

                  if (_carGraphCtrl.vehiclesList.isEmpty) {
                    return _emptyState();
                  }

                  return ListView.builder(
                    itemCount: _carGraphCtrl.vehiclesList.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      final vehicleInfo = _carGraphCtrl.vehiclesList[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.registerVehicleServiceDetailsScreen,
                            arguments: vehicleInfo.id,
                          );
                        },
                        child: CareGraphVehiclesCard(
                          vehiclesModel: vehicleInfo,
                        ),
                      );
                    },
                  );
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: NavigationHelper.backOrHome,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color:
                  Get.isDarkMode
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.white.withValues(alpha: 0.82),
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: Get.isDarkMode ? 0.08 : 0.95,
                ),
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Get.theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CareGraph',
                style: AppStyles.h2(fontFamily: 'InterSemiBold'),
              ),
              const SizedBox(height: 2),
              Text(
                'Track every vehicle and service in one timeline',
                style: AppStyles.h6(color: AppColors.subTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('My Vehicles', style: AppStyles.h3(fontFamily: 'InterSemiBold')),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _carGraphCtrl.getVehicles,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color:
                    Get.isDarkMode
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.white.withValues(alpha: 0.78),
                border: Border.all(
                  color: AppColors.borderColor.withValues(alpha: 0.45),
                ),
              ),
              child: Text(
                'Refresh',
                style: AppStyles.h6(
                  color: AppColors.brandPrimary,
                  fontFamily: 'InterSemiBold',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerCta(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => Get.toNamed(AppRoutes.addNewVehicleScreen),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(colors: AppColors.brandGradient),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.22),
              ),
              child: SvgPicture.asset(
                AppIcons.addIcon,
                fit: BoxFit.scaleDown,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register a New Vehicle',
                    style: AppStyles.h4(
                      color: Colors.white,
                      fontFamily: 'InterSemiBold',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Add specs and start service tracking',
                    style: AppStyles.h6(
                      color: Colors.white.withValues(alpha: 0.86),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:
            Get.isDarkMode
                ? const Color(0xFF151C28)
                : Colors.white.withValues(alpha: 0.88),
        border: Border.all(color: const Color(0xFFE3E8F0)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.directions_car_outlined,
            size: 34,
            color: Color(0xFF8891A5),
          ),
          const SizedBox(height: 8),
          Text(
            'No vehicles found',
            style: AppStyles.h3(fontFamily: 'InterSemiBold'),
          ),
          const SizedBox(height: 4),
          Text(
            'Add your first vehicle to start tracking service history.',
            textAlign: TextAlign.center,
            style: AppStyles.h5(color: AppColors.subTextColor),
          ),
        ],
      ),
    );
  }

  Widget _bgGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
