import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:car_care/all_export.dart';

import '../../../controllers/auth_controller.dart';
import '../../base/custom_gradiand_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Positioned(
              top: -140,
              right: -80,
              child: _orb(260, Colors.white.withValues(alpha: 0.10)),
            ),
            Positioned(
              bottom: -120,
              left: -80,
              child: _orb(240, Colors.black.withValues(alpha: 0.14)),
            ),
            SafeArea(
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Column(
                        children: [
                        Container(
                          width: 82,
                          height: 82,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.30),
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
                          'Welcome Back',
                          style: AppStyles.h2(
                            color: Colors.white,
                            fontFamily: 'InterBold',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sign in to continue your premium auto experience',
                          textAlign: TextAlign.center,
                          style: AppStyles.h6(
                            color: Colors.white.withValues(alpha: 0.88),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                hintText: 'Enter your email',
                                isEmail: true,
                                filColor: Colors.white.withValues(alpha: 0.9),
                                contenpaddingHorizontal: 14,
                                textStyle: TextStyle(color: Colors.black),
                                contenpaddingVertical: 14,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgPicture.asset(AppIcons.emailIcon),
                                ),
                                controller: authController.emailCtrl,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                hintText: 'Enter your password',
                                filColor: Colors.white,
                                isPassword: true,
                                textStyle: TextStyle(color: Colors.black),
                                contenpaddingHorizontal: 14,
                                contenpaddingVertical: 14,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 5,
                                  ),
                                  child: SvgPicture.asset(
                                    AppIcons.passwordIcon,
                                  ),
                                ),
                                controller: authController.passwordCtrl,
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.forgotEmailScreen);
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: AppStyles.h6(
                                      color: Colors.white,
                                      fontFamily: 'InterSemiBold',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Obx(
                                () => CustomGradientButton(
                                  onTap: () {
                                    authController.singIn();
                                  },
                                  loading: authController.signInLoading.value,
                                  text: 'Sign In',
                                  height: 44,
                                  borderRadius: BorderRadius.circular(14),
                                  textStyle: AppStyles.h3(
                                    color: Colors.white,
                                    fontFamily: 'InterSemiBold',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'New here? ',
                                    style: AppStyles.h6(
                                      color: Colors.white.withValues(
                                        alpha: 0.92,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(AppRoutes.signUpScreen);
                                    },
                                    child: Text(
                                      'Create account',
                                      style: AppStyles.h6(
                                        color: Colors.white,
                                        fontFamily: 'InterSemiBold',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _orb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
