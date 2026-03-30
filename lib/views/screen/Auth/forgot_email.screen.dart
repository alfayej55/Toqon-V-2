import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:car_care/all_export.dart';

import '../../../controllers/auth_controller.dart';
import '../../base/custom_gradiand_button.dart';

class ForgotEmailOtpScreen extends StatefulWidget {
  const ForgotEmailOtpScreen({super.key});

  @override
  State<ForgotEmailOtpScreen> createState() => _ForgotEmailOtpScreenState();
}

class _ForgotEmailOtpScreenState extends State<ForgotEmailOtpScreen> {
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
        title: const Text('Forgot Password'),
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
                                width: 78,
                                height: 78,
                                padding: const EdgeInsets.all(16),
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
                                'Reset Your Access',
                                style: AppStyles.h2(
                                  color: Colors.white,
                                  fontFamily: 'InterSemiBold',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Enter your email and we will send a verification code.',
                                textAlign: TextAlign.center,
                                style: AppStyles.h6(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              const SizedBox(height: 14),
                              CustomTextField(
                                hintText: 'Email address',
                                isEmail: true,
                                textStyle: TextStyle(color: Colors.black),
                                filColor: Colors.white.withValues(alpha: 0.9),
                                contenpaddingHorizontal: 14,
                                contenpaddingVertical: 14,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 5,
                                  ),
                                  child: SvgPicture.asset(AppIcons.emailIcon),
                                ),
                                controller: authController.forgotEmailCtrl,
                              ),
                              const SizedBox(height: 14),
                              Obx(
                                () => CustomGradientButton(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      authController.forgotEmail();
                                    }
                                  },
                                  loading: authController.forgotEmailLoading.value,
                                  text: 'Send OTP',
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
