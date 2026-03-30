import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:car_care/all_export.dart';


class CustomPinCodeTextField extends StatelessWidget {
  final TextEditingController? otpCtrl;
  final FormFieldValidator<String>? validator;

  const CustomPinCodeTextField({
    super.key,
    this.otpCtrl,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      backgroundColor: Colors.transparent,
      cursorColor: AppColors.primaryColor,
      controller: otpCtrl,
      textStyle: TextStyle(color: Get.textTheme.bodyMedium!.color),
      autoFocus: false,
      appContext: context,
      length: 6,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        selectedColor: AppColors.primaryColor,
        activeFillColor: AppColors.greyColor,
        selectedFillColor: AppColors.primaryColor,
        inactiveFillColor: AppColors.borderColor,
        fieldHeight: 57,
        fieldWidth: 44,
        inactiveColor: AppColors.borderColor,
        activeColor: AppColors.borderColor,
      ),
      obscureText: false,
      keyboardType: TextInputType.number,
      onChanged: (value) {},
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter OTP code';
        }
        if (value.length != 6) {
          return 'Please enter complete 6-digit OTP';
        }
        return null;
      },
    );
  }
}