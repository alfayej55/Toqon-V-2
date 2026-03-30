import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';

import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/care_care_controller.dart';
import 'package:car_care/models/care_graph_details_model.dart';
import 'package:car_care/models/vahical_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class MyRegisteredVechiclesDetails extends StatefulWidget {
  const MyRegisteredVechiclesDetails({super.key});

  @override
  State<MyRegisteredVechiclesDetails> createState() =>
      _MyRegisteredVechiclesDetailsState();
}

class _MyRegisteredVechiclesDetailsState
    extends State<MyRegisteredVechiclesDetails> {
  final CareGraphController controller = Get.find<CareGraphController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vehicleId = Get.arguments as String? ?? '';
      if (vehicleId.isNotEmpty) {
        controller.getVehicleDetails(vehicleId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: GradientAppBar(title: 'Vehicle Details', centerTitle: true),
      body: SafeArea(top: false, 
        minimum: const EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Obx(() {
          if (controller.vehicleDetailsLoading.value) {
            return const Center(child: CustomPageLoading());
          }

          final details = controller.vehicleDetails.value;
          final vehicle = details.vehicle;
          final results = details.results;

          return ListView(
            children: [
              _vehicleDetailsCard(context, vehicle, results.length),
              const SizedBox(height: 12),
              _addServiceEntryButton(),
              const SizedBox(height: 12),
              Text(
                'Service History',
                style: AppStyles.h2(fontFamily: 'InterBold'),
              ),
              const SizedBox(height: 8),
              if (results.isEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color:
                        isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.white,
                    border: Border.all(
                      color:
                          isDark
                              ? Colors.white.withValues(alpha: 0.14)
                              : const Color(0xFFE3E8F0),
                    ),
                  ),
                  child: Text(
                    'No service records found yet.',
                    style: AppStyles.h5(color: AppColors.subTextColor),
                  ),
                )
              else
                _serviceTimeline(results),
              const SizedBox(height: 14),
            ],
          );
        }),
      ),
    );
  }

  Widget _vehicleDetailsCard(
    BuildContext context,
    VehiclesModel? vehicle,
    int serviceCount,
  ) {
    final String vehicleName =
        vehicle?.vehicleName.isNotEmpty == true
            ? vehicle!.vehicleName
            : 'My Honda';

    final String vehicleInfo =
        '${vehicle?.yearOfManufacture == 0 ? 2020 : vehicle?.yearOfManufacture} '
        '${vehicle?.manufacturer.isNotEmpty == true ? vehicle!.manufacturer : 'Honda'} '
        '${vehicle?.model.isNotEmpty == true ? vehicle!.model : 'Civic'}';

    final String plate =
        vehicle?.registrationNumber.isNotEmpty == true
            ? vehicle!.registrationNumber
            : 'ABC-1234';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:
            Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white,
        border: Border.all(
          color:
              Get.isDarkMode
                  ? Colors.white.withValues(alpha: 0.14)
                  : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicleName,
                      style: AppStyles.h2(fontFamily: 'InterBold'),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      vehicleInfo,
                      style: AppStyles.h4(color: AppColors.subTextColor),
                    ),
                    Text(
                      plate,
                      style: AppStyles.h4(color: AppColors.subTextColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$serviceCount service entries recorded',
                      style: AppStyles.h5(color: AppColors.subTextColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  final url = controller.vehicleDetails.value.pdfDownloadUrl;
                  if (url.isEmpty) {
                    Get.snackbar(
                      'Export PDF',
                      'PDF export will be available soon.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  Get.snackbar(
                    'Export PDF',
                    'Downloading your service report...',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.brandPrimary),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppIcons.dawnloadIcon,
                        colorFilter: const ColorFilter.mode(
                          AppColors.brandPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Export PDF',
                        style: AppStyles.h6(
                          color: AppColors.brandPrimary,
                          fontFamily: 'InterSemiBold',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addServiceEntryButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Get.snackbar(
          'Add Service Entry',
          'Manual entry flow will be enabled next.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(colors: AppColors.brandGradient),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPrimary.withValues(alpha: 0.24),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.addIcon,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Add Service Entry',
              style: AppStyles.h4(
                color: Colors.white,
                fontFamily: 'InterSemiBold',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceTimeline(List<CareGraphResultModel> results) {
    return Stack(
      children: [
        Positioned(
          left: 12,
          top: 10,
          bottom: 10,
          child: Container(width: 2, color: const Color(0xFFDCE2EC)),
        ),
        Column(
          children: List.generate(results.length, (index) {
            final result = results[index];
            final dateText =
                result.serviceDate != null
                    ? DateFormat(
                      "yyyy-MM-dd 'at' h:mm a",
                    ).format(result.serviceDate!)
                    : 'N/A';

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == results.length - 1 ? 0 : 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.brandPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color:
                            Get.isDarkMode
                                ? Colors.white.withValues(alpha: 0.06)
                                : Colors.white,
                        border: Border.all(
                          color:
                              Get.isDarkMode
                                  ? Colors.white.withValues(alpha: 0.14)
                                  : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  result.serviceName.isNotEmpty
                                      ? result.serviceName
                                      : 'Service',
                                  style: AppStyles.h2(fontFamily: 'InterBold'),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: const Color(0xFFD8F3DF),
                                ),
                                child: Text(
                                  'Locked',
                                  style: AppStyles.h6(
                                    color: const Color(0xFF16843F),
                                    fontFamily: 'InterSemiBold',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color:
                                    Get.isDarkMode
                                        ? Color(0xFFA9B4CB)
                                        : Color(0xFF6B7384),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                dateText,
                                style: AppStyles.h4(
                                  color:
                                      Get.isDarkMode
                                          ? const Color(0xFFC3CEE4)
                                          : const Color(0xFF576073),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'Garage: ${result.garageName.isEmpty ? 'N/A' : result.garageName}',
                            style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Odometer: ${result.mileage ?? 0} ${result.mileageUnit.isEmpty ? 'km' : result.mileageUnit}',
                            style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            result.serviceDescription.isEmpty
                                ? 'No notes added for this service.'
                                : result.serviceDescription,
                            style: AppStyles.h5(
                              color:
                                  Get.isDarkMode
                                      ? const Color(0xFFB8C4DD)
                                      : const Color(0xFF3E4758),
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 15,
                                color:
                                    Get.isDarkMode
                                        ? Color(0xFFAFBBD2)
                                        : Color(0xFF5D6678),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${result.documents.length} photo${result.documents.length == 1 ? '' : 's'}',
                                style: AppStyles.h5(
                                  color:
                                      Get.isDarkMode
                                          ? const Color(0xFFAFBBD2)
                                          : const Color(0xFF5D6678),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
