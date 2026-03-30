import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:car_care/all_export.dart';

import '../../../controllers/auth_controller.dart';
import '../../base/custom_gradiand_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final Color panelColor =
        isDark
            ? const Color(0x99181F2B)
            : Colors.white.withValues(alpha: 0.16);
    final Color fieldColor =
        isDark ? const Color(0xDD1D2532) : Colors.white.withValues(alpha: 0.92);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Set New Password'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.brandGradient,
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
                  child: Form(
                    key: _formKey,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                          decoration: BoxDecoration(
                            color: panelColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.16),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.torqonLogoIcon,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Set New Password',
                                style: AppStyles.h2(
                                  color: Colors.white,
                                  fontFamily: 'InterSemiBold',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Choose a strong password to secure your account.',
                                style: AppStyles.h6(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 14),
                              CustomTextField(
                                hintText: 'New password',
                                isPassword: true,
                                textStyle: TextStyle(color: Colors.black),
                                filColor: Colors.white.withValues(alpha: 0.9),
                                contenpaddingHorizontal: 14,
                                contenpaddingVertical: 14,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 5,
                                  ),
                                  child: SvgPicture.asset(AppIcons.eyeIcon),
                                ),
                                controller: authController.newPasswordCtrl,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                hintText: 'Confirm password',
                                isPassword: true,
                                textStyle: TextStyle(color: Colors.black),
                                filColor: Colors.white.withValues(alpha: 0.9),
                                contenpaddingHorizontal: 14,
                                contenpaddingVertical: 14,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 5,
                                  ),
                                  child: SvgPicture.asset(AppIcons.eyeIcon),
                                ),
                                controller: authController.confirmPasswordCtrl,
                              ),
                              const SizedBox(height: 14),
                              Obx(
                                () => CustomGradientButton(
                                  loading: authController.otpLoading.value,
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (authController.newPasswordCtrl.text !=
                                          authController.confirmPasswordCtrl.text) {
                                        Get.snackbar(
                                          'Error',
                                          'Passwords do not match',
                                        );
                                        return;
                                      }
                                      authController.resetPassword();
                                    }
                                  },
                                  text: 'Confirm Password',
                                  height: 44,
                                  borderRadius: BorderRadius.circular(14),
                                  showGlow: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
