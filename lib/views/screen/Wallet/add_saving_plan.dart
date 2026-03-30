import 'package:car_care/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddSavingplanScreen extends StatelessWidget {
  AddSavingplanScreen({super.key});

  final amountCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: 'Saving Plan', centerTitle: true),

      body: SafeArea(top: false, 
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 35),

              /// Plan Icon
              CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFFF54924).withValues(alpha: 0.3),
                child: SvgPicture.asset(
                  AppIcons.savingIcon,
                  colorFilter: ColorFilter.mode(
                    AppColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                  height: 45,
                ),
              ),
              Text('Create Savings Plan', style: AppStyles.h3()),
              Text(
                'Set up automatic savings for your vehicles',
                style: AppStyles.h5(
                  color:
                      Get.theme.textTheme.bodyMedium!.color ??
                      AppColors.whiteColor.withValues(alpha: 0.9),
                ),
              ),

              /// Input Senction
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text('Select Vehicle', style: AppStyles.h5()),
                  SizedBox(height: 10),
                  CustomDropdown<String>(
                    items: [
                      'Toyota Camry',
                      'Honda Civic',
                      'BMW X5',
                      'Ford F-150',
                    ],
                    hint: 'Choose Vehicle',
                    onChanged: (value) {
                      // Selected: $value
                    },
                  ),

                  /// Amount Section
                  SizedBox(height: 10),
                  Text('Saving Amount', style: AppStyles.h5()),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: amountCtrl,
                    hintText: 'Amount',
                    maxLines: null,
                    contenpaddingVertical: 10,
                  ),
                  SizedBox(height: 10),

                  /// Frequency
                  Text('Frequency', style: AppStyles.h5()),
                  SizedBox(height: 10),
                  CustomDropdown<String>(
                    items: ['Daily', 'Weekly', 'Monthly'],
                    hint: 'Choose Frequency',
                    onChanged: (value) {
                      // Selected: $value
                    },
                  ),
                ],
              ),

              /// Button
              SizedBox(height: 35),
              CustomButton(
                onTap: () {
                  Get.back();
                },
                text: 'Create Savings Plan',
                height: 45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
