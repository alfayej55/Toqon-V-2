import 'package:car_care/views/base/custom_button.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

import '../../../controllers/service_controller.dart';

class ServiceBookingScreen extends StatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  State<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  final ServiceController _serviceCtrl = Get.put(ServiceController());

  late String serviceId;
  late String type;
  late double servicePrice;

  bool isPaymentLoading = false;

  List<String> timeSlots = [
    '06:00',
    '07:00',
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];
  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    serviceId = args['serviceId'] ?? '';
    type = args['type'] ?? 'manual';

    debugPrint('Typeeee>>$type');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _serviceCtrl.getVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: 'Service Booking', centerTitle: true),
      body: Obx(
        () => SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              SizedBox(height: 20),

              /// Garage Card
              _garageCard(context),

              SizedBox(height: 10),

              /// Select Time
              Text(
                'Select Time',
                style: AppStyles.h3(fontFamily: 'InterSemiBold'),
              ),
              SizedBox(height: 10),

              InkWell(
                onTap: () {
                  _serviceCtrl.selectDate(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    border: Border.all(color: AppColors.borderColor, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _serviceCtrl.selectedDate.isNotEmpty
                        ? _serviceCtrl.selectedDate.value
                        : 'Select Date',
                    style: AppStyles.h5(
                      color: Get.theme.textTheme.bodyMedium!.color,
                    ),
                  ),
                ),
              ),

              /// Time Select
              SizedBox(height: 10),
              Text(
                'Select Time',
                style: AppStyles.h3(fontFamily: 'InterSemiBold'),
              ),

              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    timeSlots.map((time) {
                      bool isSelected = _serviceCtrl.selectedTime.value == time;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _serviceCtrl.selectedTime.value = time;
                            debugPrint(
                              'Time>>>>>${_serviceCtrl.selectedTime.value}',
                            );
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColors.primaryColor
                                    : Get.theme.cardColor,
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            time,
                            style: AppStyles.h6(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : Get.theme.textTheme.bodyLarge!.color,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),

              // /// Your Info Section
              //
              // SizedBox(height: 20),
              // Text(
              //   AppString.yourInfoText,
              //   style: AppStyles.h3(fontFamily: 'InterSemiBold'),
              // ),
              // SizedBox(height: 15),
              // Text(
              //   AppString.fullNameText,
              //   style: AppStyles.h5(
              //   ),
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              // ),
              // SizedBox(height: Dimensions.heightSize,),
              // CustomTextField(
              //   controller:_serviceCtrl.nameTextCtrl,
              //   hintText:'Name',
              //   contenpaddingVertical: 10,
              // ),
              //
              // /// Nurber
              // SizedBox(height: 10),
              // Text(
              //   AppString.phoneNumberText,
              //   style: AppStyles.h5(
              //   ),
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              // ),
              // SizedBox(height: Dimensions.heightSize,),
              // CustomTextField(
              //   controller:_serviceCtrl.phoneTextCtrl,
              //   hintText:'Phone Number',
              //   keyboardType: TextInputType.phone,
              //   contenpaddingVertical: 10,
              // ),

              /// Vehicle
              SizedBox(height: 10),
              Text(
                AppString.vehicleText,
                style: AppStyles.h5(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.heightSize),

              Obx(
                () =>
                    _serviceCtrl.vehiclesLoading.value
                        ? CustomPageLoading()
                        : CustomDropdown<String>(
                          items:
                              _serviceCtrl.vehiclesList
                                  .map((service) => service.vehicleName)
                                  .toList(),
                          hint: 'Select vehicle',
                          onChanged: (value) {
                            final selectedService = _serviceCtrl.vehiclesList
                                .firstWhere(
                                  (service) => service.vehicleName == value,
                                );
                            _serviceCtrl.serviceVehicleId.value =
                                selectedService.id;
                            debugPrint(
                              'Time>>>>>${_serviceCtrl.serviceVehicleId.value}',
                            );
                          },
                        ),
              ),

              /// Descriptions / Note
              SizedBox(height: 10),
              Text(
                AppString.addNoteText,
                style: AppStyles.h5(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.heightSize),
              CustomTextField(
                controller: _serviceCtrl.descriptionTextCtrl,
                hintText: 'Write description',
                maxLines: null,
                minLines: 2,
                contenpaddingVertical: 10,
              ),

              /// Custom Button
              SizedBox(height: 10),
              CustomButton(
                loading: _serviceCtrl.bookingLoading.value,
                onTap: () {
                  _serviceCtrl.createBooking(
                    bookingType: type,
                    serviceID: serviceId,
                  );
                },
                text: 'Confirm Booking',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _garageCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Get.theme.cardColor,
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [AppStyles.boxShadow],
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
                      'Oil Change',
                      style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Jay’s Smart Garage',
                      style: AppStyles.h5(fontFamily: 'InterSemiBold'),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Estimated duration: 30 minutes',
                      style: AppStyles.h6(fontFamily: 'InterSemiBold'),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor, // Green for "Open Now"
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '\$150',
                  style: AppStyles.h6(
                    color: Colors.white,
                    fontFamily: 'InterBold',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
