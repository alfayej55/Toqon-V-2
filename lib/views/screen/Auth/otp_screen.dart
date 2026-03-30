import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:car_care/all_export.dart';

import '../../../controllers/auth_controller.dart';
import '../../base/custom_gradiand_button.dart';
import '../../base/custom_pin_code.dart';

class OtpScreen extends StatelessWidget {
   OtpScreen({super.key});

   final args = Get.arguments as Map<String, dynamic>? ?? {};
   String get type => args['type'] ?? '';
   String get email => args['email'] ?? '';

   String get maskedEmail {
     if (email.isEmpty || !email.contains('@')) return email;
     final parts = email.split('@');
     final name = parts[0];
     final domain = parts[1];
     if (name.length <= 1) return email;
     return '${name[0]}${'*' * (name.length - 1)}@$domain';
   }

  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SvgPicture.asset(AppIcons.torqonLogoIcon,height: 85,),

                SizedBox(height: Dimensions.marginSizeBetweenColumn,),

                Text('Verify Email',style: AppStyles.h1(fontFamily: 'OutfitBold')),
                SizedBox(height: 5,),
                Text(
                    "We've sent a verification code to $maskedEmail",
                     textAlign: TextAlign.center,
                    style: AppStyles.h4()),

                SizedBox(height: 30,),
                CustomPinCodeTextField(otpCtrl: authController.otpCtrl),

                SizedBox(height: 50,),

                /// Button
                Obx(() => CustomGradientButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      authController.verifyOtp(type);
                    }
                  },
                  loading: authController.otpLoading.value,
                  text: 'Verify Email',
                )),

                SizedBox(height: 25),

                Obx(() => authController.canResendOtp.value
                    ? authController.resendOtpLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : InkWell(
                            onTap: () {
                              authController.resendOtp(email);
                            },
                            child: Text(
                              'Resend code',
                              style: AppStyles.h4(decoration: TextDecoration.underline),
                            ),
                          )
                    : Text(
                        'Resend code in ${authController.formattedTime}',
                        style: AppStyles.h4(color: Colors.grey),
                      ),
                )
              ]
          ),
        ),
      ),
    );
  }
}
